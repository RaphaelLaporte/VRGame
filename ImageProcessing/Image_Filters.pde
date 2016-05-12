PImage convolute(PImage img) {

  float[][] kernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 }};

  float weight =1.f;
  // create a greyscale image (type: ALPHA) for output

  PImage result = createImage(img.width, img.height, ALPHA);
  int N = 3;
  for (int x=1; x<img.width-1; x++) {
    for (int y=1; y<img.height-1; y++) {
      int sum = 0;
      for (int i = x - N/2; i<(x+1+N/2); i++) {
        for (int j = y - N/2; j<(y+1+N/2); j++) {
          sum += brightness(img.pixels[i+j*img.width])*kernel[j-y+N/2][i-x+N/2];
        }
      }
      sum /= weight;
      result.pixels[x+y*img.width] = color(sum);
    }
  }
  // for each (x,y) pixel in the image:
  // - multiply intensities for pixels in the range
  // (x - N/2, y - N/2) to (x + N/2, y + N/2) by the
  // corresponding weights in the kernel matrix
  // - sum all these intensities and divide it by the weight
  // - set result.pixels[y * img.width + x] to this value
  return result;
}

PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  // *************************************
  // Implement here the double convolution
  // *************************************
  float weight = 1.f;
  int N=3;
  for (int x=1; x<img.width-1; x++) {
    for (int y=1; y<img.height-1; y++) {
      int sum_v = 0;
      int sum_h=0;
      for (int i = x - N/2; i<(x+1+N/2); i++) {
        for (int j = y - N/2; j<(y+1+N/2); j++) {
          sum_v += brightness(img.pixels[i+j*img.width])*vKernel[j-y+N/2][i-x+N/2];
          sum_h += brightness(img.pixels[i+j*img.width])*hKernel[j-y+N/2][i-x+N/2];
        }
      }
      sum_v /= weight;
      sum_h /= weight;
      float sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      max = max(max,sum);
      buffer[x + img.width*y] = sum;
    }
  }
  
  
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}


PImage filterThres(PImage img) {
  
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int x=0;x<img.width;x++) {
    for (int y=0; y<img.height;y++) {
      if (verifiesProperties(img.pixels[y*img.width + x])) {
        result.pixels[y*img.width + x] = color(255);
      } else {
        result.pixels[y*img.width +x] = color(0);
      }
    }
  }
  return result;
}

Boolean verifiesProperties(color c) {
  Boolean hue = hue(c)>95 && hue(c)<130;
  Boolean brightness = brightness(c)>50 && brightness(c)<140;
  Boolean saturation = saturation(c)>67 && saturation(c)<180;
  return hue && brightness && saturation;
}