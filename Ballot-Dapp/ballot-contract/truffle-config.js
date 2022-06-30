module.exports = {
  networks: {
    development: {
      host: "localhost",  //로컬 머신을 서버로 설정 
      port: 7545,         //가나쉬 블록체인 client를 위한 RPC 포트
      network_id: "5777",   
     }
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.15"      // Fetch exact version from solc-bin (default: truffle's version)
    }
  }
};
