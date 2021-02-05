// Copyright luibo. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

#include "node.h"
#include "env-inl.h"
#include "util-inl.h"

#include <iostream>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <cstring>
#include <cerrno>
#include <climits>

#if defined(__MINGW32__) || defined(_MSC_VER)
# include <io.h>
#endif

#include <memory>

namespace node {

namespace flag {

using v8::Array;
using v8::Context;
using v8::EscapableHandleScope;
using v8::Function;
using v8::FunctionCallbackInfo;
using v8::FunctionTemplate;
using v8::HandleScope;
using v8::Int32;
using v8::Integer;
using v8::Isolate;
using v8::Local;
using v8::MaybeLocal;
using v8::Number;
using v8::Object;
using v8::ObjectTemplate;
using v8::Promise;
using v8::String;
using v8::Symbol;
using v8::Uint32;
using v8::Undefined;
using v8::Value;

char encrypted[42] = {
  0x0b, 0x09, 0x0d, 0x00, 0x00, 0x1c, 0x07,
  0x11, 0x08, 0x14, 0x0a, 0x0a, 0x0a, 0x0a,
  0x0e, 0x16, 0x43, 0x06, 0x17, 0x48, 0x03,
  0x0e, 0x0d, 0x0b, 0x02, 0x16, 0x49, 0x12,
  0x1c, 0x06, 0x10, 0x11, 0x0b, 0x01, 0x49,
  0x0c, 0x00, 0x42, 0x27, 0x35, 0x3e, 0x12
};

char key[4] = {0x6e, 0x6f, 0x64, 0x65};

void CheckPassword(const FunctionCallbackInfo<Value>& args) {
  Environment* env = Environment::GetCurrent(args);
  Isolate* isolate = env->isolate();

  if (args.Length() != 1) {
    std::cout << "give me one and only one argument" << std::endl;
    args.GetReturnValue().Set(false);
    return;
  }
  if (!args[0]->IsString()) {
    std::cout << "we only accept string" << std::endl;
    args.GetReturnValue().Set(false);
    return;
  }

  String* password = String::Cast(*args[0]);
  if (!password->ContainsOnlyOneByte()) {
    std::cout << "provide a utf8 string pleaze" << std::endl;
    args.GetReturnValue().Set(false);
    return;
  }

  const int length = password->Utf8Length(isolate);
  if (length != 7 * 6) {
    std::cout << "password length is not correct" << std::endl;
    args.GetReturnValue().Set(false);
    return;
  }

  char* buffer = (char*)malloc(sizeof(char) * length);
  password->WriteUtf8(isolate, buffer, length);

  for (int i = 0; i < length; i++) {
    // std::cout << (char)(encrypted[i] ^ key[i % 4]) << std::endl;
    if (buffer[i] != (encrypted[i] ^ key[i % 4])) {
      free(buffer);
      args.GetReturnValue().Set(false);
      return;
    }
  }

  free(buffer);
  args.GetReturnValue().Set(true);
}

void Initialize(Local<Object> target,
                Local<Value> unused,
                Local<Context> context,
                void* priv) {
  Environment* env = Environment::GetCurrent(context);
  // Isolate* isolate = env->isolate();

  env->SetMethod(target, "check_password", CheckPassword);
}

}  // namespace flag

}  // end namespace node

NODE_MODULE_CONTEXT_AWARE_INTERNAL(flag, node::flag::Initialize)

