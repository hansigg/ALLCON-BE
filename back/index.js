// 내한공연 리스트
// api 쓰는 방법 노션에 정리해서 올리기

// 이게 entry point야

const express = require("express"); // express 사용하기 위해서

const app = express(); // 이제 app으로 백앤드 만들 때 쓰면 된다
const mongoose = require("mongoose");
const cors = require("cors"); // for 크롬 에뮬레이터
const moment = require("moment"); // 현재 시간 조회 for approaching
const axios = require('axios');

// -------------------- for 크롬 에뮬레이터 --------------------
app.use(cors());
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*"); // 모든 도메인에서의 요청 허용 (* 대신에 특정 도메인을 지정할 수도 있음)
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});
// ---------------------------------------------------------

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ------------------ db 스키마 ------------------
const Performance = require("./performanceSchema.js");
const Place = require("./placeSchema.js");
// ------------------ db 스키마 ------------------

// ------------------ db 스키마 ------------------
const { refreshPerformanceData } = require("./performanceDatabase.js");
const { refreshPlaceData } = require("./placeDatabase.js");
// ------------------ db 스키마 ------------------

const schedule = require("node-schedule");

const port = 8080;

// Mongoose에 연결
mongoose
  .connect("mongodb+srv://allcon:1q2w3e4r1!@allcon.pv0ucu9.mongodb.net/flutter")
  .then(() => {
    console.log("Mongoose에 연결되었습니다!");

    // -- 공연목록 전체 조회 --
    app.get("/api/get_performance", async (req, res) => {
      try {
        // 스키마에 있는 모든 정보들 찾음??
        let data = await Performance.find();
        res.status(200).json(data);
      } catch (error) {
        res.status(500).json({ error: error.message });
      }
    });


    // -- 다가오는 공연목록 전체 조회 --
    app.get("/api/get_performance/approaching", async (req, res) => {
      try {
        const currentDate = new Date();
        const twoWeeksLater = new Date();
        twoWeeksLater.setDate(currentDate.getDate() + 7);

        const customDateFormat = "yyyy.MM.dd"; // 원하는 날짜 형식을 직접 지정

        const current = formatDate(currentDate, customDateFormat);
        const twoWeeks = formatDate(twoWeeksLater, customDateFormat);

        let approachingPerformances = await Performance.find({
          startDate: {
            $gte: current,
            $lt: twoWeeks,
          },
        });

        res.status(200).json(approachingPerformances);
      } catch (error) {
        console.error("에러:", error.message);
        res.status(500).json({ error: error.message });
      }

    });
    

    //  -- 새로 추가된 공연목록 전체 조회 --
    app.get("/api/get_performance/new", async (req, res) => {
      try {
        const currentDate = new Date();
        const sevenDaysAgo = new Date();
        sevenDaysAgo.setDate(currentDate.getDate() - 7);
    
        const customDateFormat = "yyyy-MM-dd HH:mm:ss"; // update 필드의 날짜 형식
    
        const current = formatDate(currentDate, customDateFormat);
        const sevenDaysAgoFormatted = formatDate(sevenDaysAgo, customDateFormat);
    
        let approachingPerformances = await Performance.find({
          update: {
            $gte: sevenDaysAgoFormatted,
            $lt: current,
          },
        });
    
        res.status(200).json(approachingPerformances);
      } catch (error) {
        console.error("에러:", error.message);
        res.status(500).json({ error: error.message });
      }
    });


    function formatDate(date, format) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return format
        .replace("yyyy", year)
        .replace("MM", month)
        .replace("dd", day);
    }


    // -- 해당 공연장에서 열릴 공연목록 조회 --
    app.get("/api/get_performance_in_this_place/:id", async (req, res) => {
      try {
        const placeId = req.params.id;
    
        // Find performances by placeId and state
        const performances = await Performance.find({
          placeId: placeId,
          state: { $in: ['공연예정', '공연중'] }
        });
    
        // If no performances are found, respond with a 404 Not Found
        if (performances.length === 0) {
          return res.status(404).json({ error: "No performances found for this place" });
        }
    
        // If performances are found, respond with a 200 OK and the data
        res.status(200).json(performances);
      } catch (error) {
        // If any server error occurs, respond with a 500 Internal Server Error
        res.status(500).json({ error: error.message });
      }
    });
    

    // -- 공연id로 공연 조회 --
    app.get("/api/get_performance/:id", async (req, res) => {
      try {
        const performanceId = req.params.id;

        // Find the performance by ID
        const data = await Performance.findOne({ id: performanceId });

        if (!data) {
          // If no performance is found, respond with a 404 Not Found
          return res.status(404).json({ error: "Performance not found" });
        }

        // If the performance is found, respond with a 200 OK and the data
        res.status(200).json(data);
      } catch (error) {
        // If any server error occurs, respond with a 500 Internal Server Error
        res.status(500).json({ error: error.message });
      }
    });


    // -- 공연이름으로 공연 조회 --
    app.get("/api/get_performance_by_name/:name", async (req, res) => {
      try {
        const searchName = req.params.name;

        const regex = new RegExp(searchName);

        // Find performances that match either name or cast
        const data = await Performance.find({
          $or: [{ name: { $regex: regex } }, { cast: { $regex: regex } }],
        });

        if (!data || data.length === 0) {
          // If no performances are found, respond with a 404 Not Found
          return res.status(404).json({ error: "Performances not found" });
        }

        // If performances are found, respond with a 200 OK and the data
        res.status(200).json(data);
      } catch (error) {
        // If any server error occurs, respond with a 500 Internal Server Error
        res.status(500).json({ error: error.message });
      }
    });


    // ------ 시설 조회 api ------

    // -- 선택한 지역 섹션의 공연장 목록들 --
    app.get("/api/get_place/:area", async (req, res) => {
      try {
        areaKeywords = [];
        if (req.params.area == "서울") {
          areaKeywords = ["서울"];
        } else if (req.params.area == "경기,인천") {
          areaKeywords = ["경기", "인천"];
        } else if (req.params.area == "충청권") {
          areaKeywords = ["충청남도", "충청북도", "세종"];
        } else if (req.params.area == "전라권") {
          areaKeywords = ["전라남도", "전라북도", "광주"];
        } else if (req.params.area == "경상권") {
          areaKeywords = ["경상남도", "경상북도", "대구", "울산", "부산"];
        } else if (req.params.area == "강원권") {
          areaKeywords = ["강원"];
        } else if (req.params.area == "제주권") {
          areaKeywords = ["제주"];
        } else {
          res.status(400).json({ error: "Invalid area parameter" });
        }
        // Use a MongoDB query to find documents where 'adres' starts with any of the specified values
        const placeData = await Place.find({
          adres: { $regex: `^(${areaKeywords.join("|")})` },
        });
        res.status(200).json(placeData);
      } catch (error) {
        console.error("에러:", error.message);
        res.status(500).json({ error: error.message });
      }
    });

    // -- 공연장 이름으로 공연장 검색 --
    app.get("/api/get_place_by_name/:name", async (req, res) => {
      try {
        const name = req.params.name;

        // Use a MongoDB query to find documents where 'name' matches the provided name
        const placeData = await Place.find({
          name: { $regex: `.*${name}.*` },
        });

        res.status(200).json(placeData);
      } catch (error) {
        console.error("에러:", error.message);
        res.status(500).json({ error: error.message });
      }
    });


    // -- 공연장 id로 공연장 검색 --
    app.get("/api/get_place_by_id/:id", async (req, res) => {
      try {
        const placeId = req.params.id;

        // Use MongoDB query to find documents where 'id' matches the provided id
        const placeData = await Place.findOne({ id: placeId });

        if (!placeData) {
          return res.status(404).json({ error: "장소를 찾을 수 없습니다." });
        }

        res.status(200).json(placeData);
      } catch (error) {
        console.error("에러:", error.message);
        res.status(500).json({ error: error.message });
      }
    });

    
    // -------------------- 공연예술전산망 db 데이터 전체 조회 api end ------------------

    // -- 전산망 데이터 업데이트 --

    // 매일 02시 00분에 업데이트를 수행하는 함수
    function scheduleDailyUpdate() {
      // 스케줄러 설정: 매일 00시 00분
      schedule.scheduleJob("0 0 * * *", async () => {
        // 이거 작년 올해 내년 총 3년치의 공연 데이터 가져오는 걸로 바꾸자
        console.log("2년치 공연 데이터를 가져오는 중...");
        await refreshPerformanceData();

        console.log("장소 데이터를 가져오는 중...");
        await refreshPlaceData();
      });
    }
    scheduleDailyUpdate();
    
    // -- 전산망 데이터 업데이트 끝 --






        // // -- 내한 공연만 조회 -- 이건 모든 api에 옵션을 넣어야할듯??
    // app.get("/api/get_performance_visit", async (req, res) => {
    //     try {
    //       // 'visit' 필드가 'Y'인 문서들만 조회
    //       let data = await Performance.find({ visit: 'Y' });
    //       res.status(200).json(data);
    //     } catch (error) {
    //       res.status(500).json({ error: error.message });
    //     }
    //   });


    // -- 두 날짜 사이의 공연 조회 --
    // app.get("/api/get_performance/:st/:ed", async (req, res) => {
    //   try {
    //     const startDateParam = req.params.st;
    //     const endDateParam = req.params.ed;

    //     const startDate = convertParamToMongoDBFormat(startDateParam);
    //     const endDate = convertParamToMongoDBFormat(endDateParam);

    //     // MongoDB에서 startDate와 endDate 사이의 데이터를 조회

    //     let data = await Performance.find({
    //       $or: [
    //         { startDate: { $gte: startDate, $lt: endDate } },
    //         { endDate: { $gt: startDate, $lte: endDate } },
    //         {
    //           $and: [
    //             { startDate: { $lte: startDate } },
    //             { endDate: { $gte: endDate } },
    //           ],
    //         },
    //         {
    //           $and: [
    //             { startDate: { $lte: endDate } },
    //             { endDate: { $gte: startDate } },
    //           ],
    //         },
    //       ],
    //     });
    //     res.status(200).json(data);
    //   } catch (error) {
    //     res.status(500).json({ error: error.message });
    //   }

    //   // -- db 데이터 날짜 조회 --
    //   function convertParamToMongoDBFormat(dateParam) {
    //     const year = dateParam.substring(0, 4);
    //     const month = dateParam.substring(4, 6);
    //     const day = dateParam.substring(6, 8);
    //     return `${year}.${month}.${day}`;
    //   }
    // });


  })
  .catch((error) => {
    console.error("Mongoose에 연결 중 오류 발생:", error);
  });

app.listen(port, () => {
  console.log(`listening on port ${port}`);
});
