const mongoose = require('mongoose');
const axios = require('axios');
const parseString = require('xml2js').parseString;
const Place = require('./placeSchema'); // Import the Place model

// MongoDB 연결
mongoose.connect("mongodb+srv://allcon:1q2w3e4r1!@allcon.pv0ucu9.mongodb.net/flutter");

// 장소 세부 정보 저장
const savePlaceData = async (mt10id) => {
    try {
        const response = await axios.get(`http://www.kopis.or.kr/openApi/restful/prfplc/${mt10id}?service=d62a777fa5ce4ea1ae450abffb03e97d&newsql=Y`);
        const xmlData = response.data;

        parseString(xmlData, { explicitArray: false }, async (err, result) => {
            if (err) {
                console.error('XML 파싱 오류:', err);
                return;
            }

            const placeData = result.dbs.db;
            const newPlace = new Place({
                id: placeData.mt10id,
                name: placeData.fcltynm || '',
                open: placeData.opende || '',
                scale: placeData.seatscale || '',
                tele: placeData.telno || '',
                url: placeData.relateurl || '',
                adres: placeData.adres || '',
                parking: placeData.parkinglot || '',
                chart: placeData.fcltychartr || ''
            });

            await newPlace.save();
            console.log('장소 세부 정보가 성공적으로 저장되었습니다:', newPlace);
        });
    } catch (error) {
        console.error('장소 세부 정보를 가져오는 중 오류 발생:', error);
    }
};

// 전체 데이터 조회 및 저장 또는 업데이트
const getAllPlaceData = async () => {
    try {
        const response = await axios.get('http://www.kopis.or.kr/openApi/restful/prfplc?service=d62a777fa5ce4ea1ae450abffb03e97d&cpage=1&rows=10000');
        const xmlData = response.data;

        parseString(xmlData, { explicitArray: false }, async (err, result) => {
            if (err) {
                console.error('XML 파싱 오류:', err);
                return;
            }

            const placeList = result.dbs.db;
            for (const place of placeList) {
                await savePlaceData(place.mt10id);
            }
        });
    } catch (error) {
        console.error('장소 데이터를 가져오는 중 오류 발생:', error);
    }
};

// 전체 데이터 삭제
const removeAllPlaceData = async () => {
    try {
        await Place.deleteMany({});
        console.log('모든 장소 데이터가 성공적으로 삭제되었습니다.');
    } catch (error) {
        console.error('장소 데이터 삭제 중 오류 발생:', error);
    }
};

// 데이터 삭제 후 새로운 데이터 저장
const refreshPlaceData = async () => {
    await removeAllPlaceData();
    await getAllPlaceData();
};

module.exports = {
    refreshPlaceData
  }



// -------------
// const mongoose = require('mongoose');
// const axios = require('axios');
// const parseString = require('xml2js').parseString;
// const Place = require('./placeSchema'); // Import the Place model

// // MongoDB 연결
// mongoose.connect("mongodb+srv://allcon:1q2w3e4r1!@allcon.pv0ucu9.mongodb.net/flutter", { useNewUrlParser: true, useUnifiedTopology: true });

// const saveOrUpdatePlaceDetails = async (mt10id) => {
//     try {
//         const response = await axios.get(`http://www.kopis.or.kr/openApi/restful/prfplc/${mt10id}?service=d62a777fa5ce4ea1ae450abffb03e97d&newsql=Y`);
//         const xmlData = response.data;

//         parseString(xmlData, { explicitArray: false }, async (err, result) => {
//             if (err) {
//                 console.error('XML 파싱 오류:', err);
//                 return;
//             }

//             const placeData = result.dbs.db;
//             const existingPlace = await Place.findOne({ id: placeData.mt10id });

//             if (existingPlace) {
//                 // 이미 존재하는 문서를 업데이트
//                 existingPlace.name = placeData.fcltynm || '';
//                 existingPlace.open = placeData.opende || '';
//                 existingPlace.scale = placeData.seatscale || '';
//                 existingPlace.tele = placeData.telno || '';
//                 existingPlace.url = placeData.relateurl || '';
//                 existingPlace.adres = placeData.adres || '';
//                 existingPlace.parking = placeData.parkinglot || '';
//                 existingPlace.chart = placeData.fcltychartr || '';

//                 await existingPlace.save();
//                 console.log('장소 세부 정보가 성공적으로 업데이트되었습니다:', existingPlace);
//             } else {
//                 // 기존 문서가 없으므로 새로운 문서를 삽입
//                 const newPlace = new Place({
//                     id: placeData.mt10id,
//                     name: placeData.fcltynm || '',
//                     open: placeData.opende || '',
//                     scale: placeData.seatscale || '',
//                     tele: placeData.telno || '',
//                     url: placeData.relateurl || '',
//                     adres: placeData.adres || '',
//                     parking: placeData.parkinglot || '',
//                     chart: placeData.fcltychartr || ''
//                 });

//                 await newPlace.save();
//                 console.log('장소 세부 정보가 성공적으로 저장되었습니다:', newPlace);
//             }
//         });
//     } catch (error) {
//         console.error('장소 세부 정보를 가져오는 중 오류 발생:', error);
//     }
// };

// // 전체 데이터 조회 및 저장 또는 업데이트
// const getAllPlaceData = async () => {
//     try {
//         const response = await axios.get('http://www.kopis.or.kr/openApi/restful/prfplc?service=d62a777fa5ce4ea1ae450abffb03e97d&cpage=1&rows=10000');
//         const xmlData = response.data;

//         parseString(xmlData, { explicitArray: false }, async (err, result) => {
//             if (err) {
//                 console.error('XML 파싱 오류:', err);
//                 return;
//             }

//             const placeList = result.dbs.db;
//             for (const place of placeList) {
//                 await saveOrUpdatePlaceDetails(place.mt10id);
//             }
//         });
//     } catch (error) {
//         console.error('장소 데이터를 가져오는 중 오류 발생:', error);
//     }
// };

// getAllPlaceData();
