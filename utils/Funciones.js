function OldEncodeTime(year, mon, day, hour, min, sec) {
    let tt = 0
    tt = ((year - 2000) * 12 * 31 + ((mon - 1) * 31) + day - 1) * (24 * 60 * 60) + (hour * 60 + min) * 60 + sec;
    return tt
}

module.exports = {
    OldEncodeTime
}