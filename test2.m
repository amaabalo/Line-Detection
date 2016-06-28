test.name = 'B.png';
test.p = [123; 59];
test.q = [41; 76];
save test;
load test;
linedetect(test);