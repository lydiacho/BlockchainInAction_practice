var express = require('express');
var app = express();

app.use(express.static('src')); //src : 퍼블릭 웹 artifact를 위한 베이스 디렉토리
app.use(express.static('../ballot-contract/build/contracts'))   //ABI 파일 위치
app.get('/', function(req, res) {
    res.render('index.html');   //index.html : 웹 앱 랜딩 페이지
});
app.listen(3000, function() {   //3000 : Node.js 서버 포트
    console.log('Example app listening on port 3000!');
});