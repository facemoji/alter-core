float rndGen(float2 v) {
    return fract(43757.5453 * sin(dot(v, float2(12.9898, 78.233))));
}



float rndTransPoly(float x, float kurtosis) {
    float exponent = 1. / (1. + kurtosis);
    return 0.5 * (pow(x, exponent) + (1. - pow(1. - x, exponent)));
}
float rndTransPolyMedian(float x, float kurtosis, float median) {
    float y = rndTransPoly(x, kurtosis);
    if (y >= 0.5) return 1. - 2. * (1. - y) * (1. - median); else return median * y * 2.;
}
float rndTransPolyMode(float x, float kurtosis, float mode) {
    if (x > mode)
        return rndTransPolyMedian(1. - 0.5 * (1. - x) / (1. - mode), kurtosis, mode);
    else
        return rndTransPolyMedian(0.5 * x / mode, kurtosis, mode);
}


float rndTransPoly(float x, float kurtosis, float2 interval) {
    return interval.x + rndTransPoly(x, kurtosis) * (interval.y - interval.x);
}
float rndTransPolyMedian(float x, float kurtosis, float median, float2 interval) {
    float range = interval.y - interval.x;
    return interval.x + rndTransPolyMedian(x, kurtosis, (median - interval.x) / range) * range;
}
float rndTransPolyMode(float x, float kurtosis, float mode, float2 interval) {
    float range = interval.y - interval.x;
    return interval.x + rndTransPolyMode(x, kurtosis, (mode - interval.x) / range) * range;
}



float rndTransPoly(float x, float kurtosis, float rareShare) {
    if (x <= rareShare) return x / rareShare; else return rndTransPoly((x - rareShare) / (1. - rareShare), kurtosis);
}
float rndTransPolyMedian(float x, float kurtosis, float median, float rareShare) {
    if (x <= rareShare) return x / rareShare; else return rndTransPolyMedian((x - rareShare) / (1. - rareShare), kurtosis, median);
}
float rndTransPolyMode(float x, float kurtosis, float mode, float rareShare) {
    if (x <= rareShare) return x / rareShare; else return rndTransPolyMode((x - rareShare) / (1. - rareShare), kurtosis, mode);
}


float rndTransPoly(float x, float kurtosis, float2 interval, float rareShare) {
    return interval.x + rndTransPoly(x, kurtosis, rareShare) * (interval.y - interval.x);
}
float rndTransPolyMedian(float x, float kurtosis, float median, float2 interval, float rareShare) {
    float range = interval.y - interval.x;
    return interval.x + rndTransPolyMedian(x, kurtosis, (median - interval.x) / range, rareShare) * range;
}
float rndTransPolyMode(float x, float kurtosis, float mode, float2 interval, float rareShare) {
    float range = interval.y - interval.x;
    return interval.x + rndTransPolyMode(x, kurtosis, (mode - interval.x) / range, rareShare) * range;
}
