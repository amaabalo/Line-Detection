test.name = 'Image.jpg';
test.p = [173; 118];
test.q = [171; 232];
save test;
load test;
linedetect(test);