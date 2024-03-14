
// 공연장 스키마 정의

const mongoose = require('mongoose');

// mongoDB 스키마 정의
const placeSchema = new mongoose.Schema({
    id: {
        type: String,
        unique: true,
        required: true,
        index: true
    },
    name: String,
    open: String,
    scale: String,
    tele: String,
    url: String,
    adres: String,
    parking: String,
    chart: String
});

const Place = mongoose.model('Place', placeSchema);

module.exports = Place;

