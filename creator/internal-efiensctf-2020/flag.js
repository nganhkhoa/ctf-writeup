const { check_password } = internalBinding('flag');

function easy(input_flag) {
  let flag_components = input_flag.split('-');
  let message = '';
  let x = 0x9bc19a11;
  while (x !== 0xdeadbeef) {
    switch(x) {
      case 0x54f5d109: {
        message = 'You are dead wrong';
        x = 0xdeadbeef;
        break;
      }
      case 0x22f1dede: {
        message = 'The flag is efiensctf{' + input_flag + '}';
        x = 0xdeadbeef;
        break;
      }
      case 0x9bc19a11: {
        x = flag_components.length === 4
          ? 0xab9a16fd
          : 0x54f5d109;
        break;
      }
      case 0x589f0521: {
        x = flag_components[0] === 'do'
          ? 0x27c501f3
          : 0x54f5d109;
        flag_components.shift();
        break;
      }
      case 0x0e2c6464: {
        x = flag_components[0] === 'know'
          ? 0x22f1dede
          : 0x54f5d109;
        flag_components.shift();
        break;
      }
      case 0x27c501f3: {
        x = flag_components[0] === 'you'
          ? 0x0e2c6464
          : 0x54f5d109;
        flag_components.shift();
        break;
      }
      case 0xab9a16fd: {
        x = flag_components[0] === 'nodejs'
          ? 0x589f0521
          : 0x54f5d109;
        flag_components.shift();
        break;
      }
    }
  }
  return message;
}

function medium(pass) {
  if (check_password(pass)) {
    console.log("Submit the password as flag");
  }
  else {
    console.log("What did you miss?");
  }
}

module.exports = flag = {
  easy,
  medium,
};
