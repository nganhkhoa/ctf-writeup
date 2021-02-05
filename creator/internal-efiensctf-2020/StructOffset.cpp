#include <cstdlib>
#include <stack>

#include "llvm/ADT/StringRef.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

#include "CryptoUtils.h"

using namespace llvm;

#define DEBUG_TYPE "structoffset"

namespace {
struct StructOffsetJni : public FunctionPass {
  static char ID;
  StructOffsetJni() : FunctionPass(ID) {}

  bool runOnFunction(Function& F) override {
    int var_count = 15;  // a random number for debugging in IR
    llvm::cryptoutils->prng_seed();
    std::stack<Instruction*> old_gets;
    DataLayout* dtl = new DataLayout(F.getParent());
    unsigned int ptr_size =
        dtl->getPointerTypeSizeInBits(Type::getInt32PtrTy(F.getContext()));

    for (auto i = F.begin(); i != F.end(); i++) {
      BasicBlock* blk = &*i;
      for (auto ii = blk->begin(); ii != blk->end(); ii++) {
        Instruction* insn = &*ii;
        if (insn->getOpcode() != Instruction::GetElementPtr) continue;
        GetElementPtrInst* ele = (GetElementPtrInst*)insn;
        Type* source = ele->getSourceElementType();
        if (!source->isStructTy() ||
            source->getStructName().str() != "struct.JNINativeInterface_")
          continue;

        old_gets.push(insn);
        insn = insn->getNextNonDebugInstruction();

        // We are at the `getelementptr` instruction of the code
        // Because `JNINativeInterface_` is a struct with only pointers
        // we can consider it as an array of pointers
        //
        // It could be similar to the conversion from
        //    ```
        //    struct JNINativeInterface_ env;
        //    (*env)->doSomething(args);
        //    ````
        // to
        //    ```
        //    struct JNINativeInterface_ env;
        //    typedef rettype (*doSomething)(args...);
        //    (doSomething)((int*)(*env)[doSomethingOffset])(args...);
        //    ```
        // We first cast the `struct*` to an `int*`
        // Calculate the new offset
        // Add the base address to the offset to get the address to member
        // Cast the address to a function pointer and call with the same
        // arguments
        //
        // In LLVM, when `(*env)->doSomething` is accessed the LLVM IR
        // generates a `getelementptr` instruction like this:
        //    ```
        //    getelementptr inbounds
        //      %struct.JNINativeInterface_,
        //      %struct.JNINativeInterface_* %R,
        //      i32 0,
        //      i32 memberIndex
        //    ````
        //    Where:
        //      %R is the pointer to the struct
        //      memberIndex is the index of the member in struct
        //      the third argument is 0 if %R is a pointer to the struct
        //        this is actually the same as how many dereference is needed
        //        *%R -> 0
        //        **%R -> 1
        //
        // We replace this instruction with
        //    ```
        //    %10 = bitcast %struct.JNINativeInterface_* %R to i64*
        //    %19 = getelementptr inbounds i64, i64* %10, i64 %OFFSET
        //    %20 = bitcast i64* %19 to FUNC_TYPE*
        //    %21 = load FUNC_TYPE, FUNC_TYPE* %20, align 8
        //
        //    where FUNC_TYPE is
        //      i8* (%struct.JNINativeInterface_**, %struct._jobject*, i8*)*
        //    ```
        // After that, we generate the equation to OFFSET (see below)
        // which makes it harder to reverse

        // generates a temp variable
        Twine var_name = Twine(var_count);
        AllocaInst* var =
            new AllocaInst(Type::getInt32Ty(F.getContext()), 0, var_name, insn);
        ConstantInt* y =
            ConstantInt::getSigned(Type::getInt32Ty(F.getContext()),
                                   llvm::cryptoutils->get_range(50, 100));
        new StoreInst(y, var, insn);

        Value* as_array = new BitCastInst(
            ele->getPointerOperand(),
            Type::getIntNPtrTy(F.getContext(), ptr_size), "", insn);

        ConstantInt* index = (ConstantInt*)ele->getOperand(2);
        BinaryOperator* new_index = nullptr;
        if (index->isZero()) {
          // generates the equation:
          // a * y + b * y - c * y which is equal to 0
          // where
          //    a + b = c
          //    y is a random number
          //
          // beware of bit size, we are using int32
          // we have 31 bits to use, make sure not to overflow
          //
          // d is roughly 1000 to 2000
          // a will have about 21 bits
          // b = c - a = -(a - c)

          int a_max = 1 << 21;
          int a_min = 1 << 20;
          // c is negative to mul easier
          ConstantInt* c =
              ConstantInt::getSigned(Type::getInt32Ty(F.getContext()),
                                     llvm::cryptoutils->get_range(1000, 2000));
          ConstantInt* a = ConstantInt::getSigned(
              Type::getInt32Ty(F.getContext()),
              llvm::cryptoutils->get_range(a_min, a_max));
          // calculate b = -(a + (-c))
          int b_value = -((int)a->getZExtValue() + (int)c->getZExtValue());
          ConstantInt* b =
              ConstantInt::getSigned(Type::getInt32Ty(F.getContext()), b_value);

          // a * y + b * y
          LoadInst* l1 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* a_m =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, a, l1, "", insn);
          LoadInst* l2 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* b_m =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, b, l2, "", insn);
          BinaryOperator* left = BinaryOperator::CreateNSW(BinaryOperator::Add,
                                                           a_m, b_m, "", insn);
          // - c * y
          LoadInst* l3 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* right =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, c, l3, "", insn);

          new_index = BinaryOperator::CreateNSW(BinaryOperator::Add, left,
                                                right, "", insn);
        } else {
          // generates the equation:
          // a * y + b * y + index * (1 - d * y) which is equal to index
          // where
          //    index != 0
          //    a + b = d * index
          //    y is a random number
          //
          // beware of bit size, we are using int32
          // we have 31 bits to use, make sure not to overflow
          //
          // d is roughly 1000 to 2000
          // a will have about 21 bits
          // b = (index * d - a) = -(a - index * d)

          int a_max = 1 << 21;
          int a_min = 1 << 20;
          // d is negative to mul easier
          ConstantInt* d =
              ConstantInt::getSigned(Type::getInt32Ty(F.getContext()),
                                     llvm::cryptoutils->get_range(1000, 2000));
          ConstantInt* a = ConstantInt::getSigned(
              Type::getInt32Ty(F.getContext()),
              llvm::cryptoutils->get_range(a_min, a_max));
          // calculate b = -(a + (index * -d)))))
          int b_value = -((int)a->getZExtValue() +
                          (int)index->getZExtValue() * (int)d->getZExtValue());
          ConstantInt* b =
              ConstantInt::getSigned(Type::getInt32Ty(F.getContext()), b_value);
          ConstantInt* one =
              ConstantInt::getSigned(Type::getInt32Ty(F.getContext()), 1);

          // a * y + b * y
          LoadInst* l1 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* a_m =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, a, l1, "", insn);
          LoadInst* l2 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* b_m =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, b, l2, "", insn);
          BinaryOperator* left = BinaryOperator::CreateNSW(BinaryOperator::Add,
                                                           a_m, b_m, "", insn);
          // index * (1 - d * y)
          LoadInst* l3 = new LoadInst(Type::getInt32Ty(F.getContext()), var,
                                      var_name, insn);
          BinaryOperator* d_m =
              BinaryOperator::CreateNSW(BinaryOperator::Mul, d, l3, "", insn);
          BinaryOperator* add_one = BinaryOperator::CreateNSW(
              BinaryOperator::Add, d_m, one, "", insn);
          BinaryOperator* right = BinaryOperator::CreateNSW(
              BinaryOperator::Mul, index, add_one, "", insn);

          new_index = BinaryOperator::CreateNSW(BinaryOperator::Add, left,
                                                right, "", insn);
        }
        GetElementPtrInst* new_get =
            GetElementPtrInst::CreateInBounds(as_array, {
              // getelementptr reuires the index to be int64
              new SExtInst(new_index, Type::getInt64Ty(F.getContext()), "",
                           insn);
            }, "", insn);

        // store
        if (StoreInst::classof(insn)) {
          // may not need, no one set on JNIEnv
          insn->setOperand(1, new_get);
        }
        // load
        else if (LoadInst::classof(insn)) {
          // cast the int* to function pointer
          // the type of the function pointer is load type
          Value* func_ptr = new BitCastInst(
              new_get, ((LoadInst*)insn)->getPointerOperandType(), "", insn);
          insn->setOperand(0, func_ptr);
        } else {
          errs() << "Unknown instruction after getptr:\n\t" << *insn << "\n";
        }

        var_count += 1;
      }
    }
    // erase old gets
    while (!old_gets.empty()) {
      old_gets.top()->eraseFromParent();
      old_gets.pop();
    }
    return false;
  }
};
}

char StructOffsetJni::ID = 1;
static RegisterPass<StructOffsetJni> JNI("jnienv",
                                         "Randomly offset JNIEnv's members");

