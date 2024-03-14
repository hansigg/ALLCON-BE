// db로 저장하는 코드임

const mongoose = require("mongoose");
const axios = require("axios");
const parseString = require("xml2js").parseString;
const Performance = require("./performanceSchema"); // Import the Performance model

// MongoDB 연결
mongoose.connect("mongodb+srv://allcon:1q2w3e4r1!@allcon.pv0ucu9.mongodb.net/flutter");

// XML 데이터를 가져와서 처리하는 함수
async function processXmlData(xmlData) {
  try {
    const result = await parseXmlData(xmlData);
    const performances = result.dbs.db;

    for (const performance of performances) {
      const mt20id = performance.mt20id[0];

      // mt20id로 상세 정보 조회
      const detailApiUrl = `https://www.kopis.or.kr/openApi/restful/pblprfr/${mt20id}?service=d62a777fa5ce4ea1ae450abffb03e97d&newsql=Y`;

      try {
        const detailResponse = await axios.get(detailApiUrl);
        const detailXmlData = detailResponse.data;
        const detailResult = await parseXmlData(detailXmlData);

        const detailPerformance = detailResult.dbs.db[0];

        // 여기서 필요한 정보 추출
        const performanceData = {
          id: detailPerformance.mt20id[0], // api로 받은 공연 id값
          name: detailPerformance.prfnm[0], // 공연 이름
          cast: detailPerformance.prfcast[0], // 공연 출연자
          startDate: detailPerformance.prfpdfrom[0], // 시작날짜
          endDate: detailPerformance.prfpdto[0], // 종료 날짜
          place: detailPerformance.fcltynm[0], // 공연장
          placeId: detailPerformance.mt10id[0], // api로 받은 공연장 id
          age: detailPerformance.prfage[0], // 제한 나이
          area: detailPerformance.area[0], // 공연장 지역구?
          price: detailPerformance.pcseguidance[0], // 가격
          visit: detailPerformance.visit[0], // 내한여부
          state: detailPerformance.prfstate[0], // 공연 상태 - 예정, 진행중, 종료 
          time: detailPerformance.dtguidance[0], // 공연 시간
          genre: detailPerformance.genrenm[0], // 공연 장르
          poster: detailPerformance.poster[0], // 포스터
          imgs: detailPerformance.styurls[0] // 이미지들
            ? detailPerformance.styurls[0].styurl
            : [],
          update: detailPerformance.updatedate[0], // 최종 업데이트 날짜
        };

        // MongoDB에 저장
        const newPerformance = new Performance(performanceData);
        await newPerformance.save();
        // 데이터를 저장한 후 출력
        console.log(`Performance with mt20id ${mt20id} saved to MongoDB`);
      } catch (error) {
        console.error(
          `Error fetching/detailing data for mt20id ${mt20id}:`,
          error
        );
      }
    }
  } catch (error) {
    console.error("Error parsing XML data:", error);
  }
}

// API 호출 및 데이터 처리
async function fetchDataByDateRange(stdate, eddate) {
  try {
    const apiUrl = `https://kopis.or.kr/openApi/restful/pblprfr?service=d62a777fa5ce4ea1ae450abffb03e97d&stdate=${stdate}&eddate=${eddate}&cpage=1&rows=10000&newsql=Y&shcate=CCCD`;
    const response = await axios.get(apiUrl);
    const xmlData = response.data;
    await processXmlData(xmlData);
  } catch (error) {
    console.error("Error fetching data from API:", error);
  }
}

// XML 데이터 파싱 함수
async function parseXmlData(xmlData) {
  return new Promise((resolve, reject) => {
    parseString(xmlData, (err, result) => {
      if (err) {
        reject(err);
      } else {
        resolve(result);
      }
    });
  });
}

// 전체 데이터 삭제
const removeAllPerformanceData = async () => {
  try {
    await Performance.deleteMany({});
    console.log("모든 장소 데이터가 성공적으로 삭제되었습니다.");
  } catch (error) {
    console.error("장소 데이터 삭제 중 오류 발생:", error);
  }
};

// 데이터 삭제 후 새로운 데이터 저장
const getPerformanceData = async () => {
  
  // Get the current year
  const currentYear = new Date().getFullYear();

  // Iterate over the next three years (2023, 2024, 2025)
  for (let year = currentYear - 1; year <= currentYear; year++) {
    // Iterate over each month (1 to 12)
    for (let month = 1; month <= 12; month++) {
      // Pad month with leading zero if needed
      const formattedMonth = month.toString().padStart(2, '0');

      // Create start and end date for the month
      const startDate = `${year}${formattedMonth}01`;
      const endDate = `${year}${formattedMonth}31`;

      // Fetch and save data for the current month
      await fetchDataByDateRange(startDate, endDate);
    }
  }
};

// Call the modified refreshPerformanceData function
// refreshPerformanceData();


const refreshPerformanceData = async () => {
  await removeAllPerformanceData();
  await getPerformanceData();
};


module.exports = {
  refreshPerformanceData,
};

// -----------------------------
// // db로 저장하는 코드임

// const mongoose = require('mongoose');
// const axios = require('axios');
// const parseString = require('xml2js').parseString;
// const Performance = require('./performanceSchema'); // Import the Performance model
// const moment = require('moment');

// // MongoDB 연결
// mongoose.connect("mongodb+srv://allcon:1q2w3e4r1!@allcon.pv0ucu9.mongodb.net/flutter", { useNewUrlParser: true, useUnifiedTopology: true });

// // XML 데이터를 가져와서 처리하는 함수
// async function processXmlData(xmlData) {
//   try {
//     const result = await parseXmlData(xmlData);
//     const performances = result.dbs.db;

//     for (const performance of performances) {
//       const mt20id = performance.mt20id[0];

//       // mt20id로 상세 정보 조회
//       const detailApiUrl = `https://www.kopis.or.kr/openApi/restful/pblprfr/${mt20id}?service=d62a777fa5ce4ea1ae450abffb03e97d&newsql=Y`;

//       try {
//         const detailResponse = await axios.get(detailApiUrl);
//         const detailXmlData = detailResponse.data;
//         const detailResult = await parseXmlData(detailXmlData);

//         const detailPerformance = detailResult.dbs.db[0];

//         // 여기서 필요한 정보 추출
//         const performanceData = {
//           id: detailPerformance.mt20id[0],
//           name: detailPerformance.prfnm[0],
//           startDate: detailPerformance.prfpdfrom[0],
//           endDate: detailPerformance.prfpdto[0],
//           place: detailPerformance.fcltynm[0],
//           placeId: detailPerformance.mt10id[0],
//           age: detailPerformance.prfage[0],
//           area: detailPerformance.area[0],
//           price: detailPerformance.pcseguidance[0],
//           visit: detailPerformance.visit[0],
//           state: detailPerformance.prfstate[0],
//           time: detailPerformance.dtguidance[0],
//           genre: detailPerformance.genrenm[0],
//           poster: detailPerformance.poster[0],
//           imgs: detailPerformance.styurls[0] ? detailPerformance.styurls[0].styurl : [],
//           update: detailPerformance.updatedate[0],
//         };

//         // MongoDB에 저장
//         await savePerformanceToMongoDB(performanceData);

//         // 데이터를 저장한 후 출력
//         console.log(`Performance with mt20id ${mt20id} saved to MongoDB`);
//       } catch (error) {
//         console.error(`Error fetching/detailing data for mt20id ${mt20id}:`, error);
//       }
//     }
//   } catch (error) {
//     console.error('Error parsing XML data:', error);
//   }
// }

// // API 호출 및 데이터 처리
// async function fetchDataByDateRange(stdate, eddate) {
//   try {
//     const apiUrl = `https://kopis.or.kr/openApi/restful/pblprfr?service=d62a777fa5ce4ea1ae450abffb03e97d&stdate=${stdate}&eddate=${eddate}&cpage=1&rows=1000&newsql=Y&shcate=CCCD`;
//     const response = await axios.get(apiUrl);
//     const xmlData = response.data;
//     await processXmlData(xmlData);
//   } catch (error) {
//     console.error('Error fetching data from API:', error);
//   }
// }

// // XML 데이터 파싱 함수
// async function parseXmlData(xmlData) {
//   return new Promise((resolve, reject) => {
//     parseString(xmlData, (err, result) => {
//       if (err) {
//         reject(err);
//       } else {
//         resolve(result);
//       }
//     });
//   });
// }

// // 다음 6개월의 날짜 범위를 가져오는 함수
// function getNextSixMonthsDateRange() {
//   const startDate = moment().format('YYYYMMDD'); // 오늘 날짜
//   const endDate = moment().add(6, 'months').format('YYYYMMDD'); // 오늘로부터 6개월 뒤
//   return { startDate, endDate };
// }

// // 다음 6개월 동안 데이터를 가져오는 함수
// async function fetchNextSixMonthsData() {
//   const { startDate, endDate } = getNextSixMonthsDateRange();
//   await fetchDataByDateRange(startDate, endDate);
// }

// // MongoDB에 저장 함수
// async function savePerformanceToMongoDB(performanceData) {
//   try {
//     // 기존 문서가 없으므로 문서를 삽입
//     await Performance.create(performanceData);
//   } catch (error) {
//     console.error(`Error saving performance data to MongoDB:`, error);
//   }
// }

// async function clearAndSavePerformanceToMongoDB(performanceDataArray) {
//   // 기존 데이터 모두 삭제
//   try {
//       await Performance.deleteMany({});
//       console.log('공연 데이터 삭제 성공');
//   } catch(error){
//       console.error('공연 데이터 삭제 중 오류 발생:', error);
//   }

//   // 새로운 데이터 삽입
//   try {
//     await Performance.insertMany(performanceDataArray);
//     console.log('공연 데이터 삽입 성공');
//   } catch (error) {
//     console.error(`Error clearing and saving performance data to MongoDB:`, error);
//   }
// }

// module.exports = {
//   clearAndSavePerformanceToMongoDB
// }
