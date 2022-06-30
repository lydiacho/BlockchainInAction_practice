var Ballot = artifacts.require("Ballot");  //배포할 스마트 컨트랙트 명시

module.exports = function(deployer) {
    deployer.deploy(Ballot,4);          //생성자의 파라미터였던 제안 수를 4로 설정하여 배포 
};