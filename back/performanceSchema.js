
// 공연정보 스키마 정의
const mongoose = require("mongoose")

// MongoDB 스키마 정의
const performanceSchema = new mongoose.Schema({
  id: {
      type: String,
      unique: true, // 'id' 필드가 고유하도록 설정
      required: true, // 'id' 필드가 필수로 되도록 설정
      index: true // 'id' 필드에 대한 인덱스를 생성하여 빠른 쿼리를 위해 설정
  },
  name: String,
  cast : String,
  startDate: String,
  endDate: String,
  place: String,
  placeId: String,
  age: String,
  area: String,
  price: String,
  visit: String,
  state: String,
  time: String,
  genre: String,
  poster: String,
  imgs: [String], // 여러 이미지가 들어갈 수도 있음
  update: String,
});


// mongoose.model(데이터를 받을 컬렉션 이름, 넘길 데이터를 가진스키마 이름)
const Performance =  mongoose.model('Performance', performanceSchema)

module.exports = Performance


// node data라는 컬렉션에 infoSchema의 데이터를 넘기는 거임
// 이렇게 만들고 server.js에서
// const 변수이름 = require('./info')로 이 파일의 코드를 가져다가 쓸 수 있다