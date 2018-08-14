
int p[];
// initialize the improved perlin noise algorithm with an array
// p[] is used in a hash function that defines our gradient vectors
//================================================================

// our noise function takes in strictly 3 parameters
// this is different from the primitive noise algorithm which can accept 1, 2, and 3 parameters
// note that we transform using a hash function
// that means this maps the position of each pixel
// into a noise algorithm, but does so in the way that is pseudorandom
// this creates the effect of 'noise'
// which is random but somewhat symmetrical
// (this is an extremely precise mathematical term)

float pNoise(float x, float y, float z) {
  // calculate the unit cube
  // so we can specify the location of each point

  // left bound
  // ( |_x_|,|_y_|,|_z_| )

  // right bound
  // ( |_x_|,|_y_|,|_z_| )+1. 
  // calculate location (from 0.0 to 1.0)
  // inside of cube.


  // we use modular remainder operation to handle overflow so it 'repeats'
  // x,y,z coordinates represent points inside of unit cube
  // perlin noise repeats [0-255]
  /*
  // you can use floor()
   // there isn't really a difference between floor(); and int(); 
   
   // 
   int X = floor(x) & 255;
   int Y = floor(y) & 255;
   int Z = floor(z) & 255;
   x -= floor(x);
   y -= floor(y);
   z -= floor(z);
   */


  // i forget where i read that using int() speeds up the algorithm
  // creates smoother motion
  // it seems to work
  int X = int(x) & 255;
  int Y = int(y) & 255;
  int Z = int(z) & 255;
  x -= int(x);
  y -= int(y);
  z -= int(z);

  // if you want a strange grid effect or manipulate the 'tiling' of the noise algorithm

  /*
  int X = round(x) & 255;
   int Y = round(y) & 255;
   int Z = int(z) & 255;
   x -= int(x);
   y -= int(y);
   z -= int(z);
   */

  //
  float u = fade(x);
  float v = fade(y);
  float w = fade(z);    

  // any function
  // that can be used to map
  // data of arbitrary size
  // to data of fixed size
  // with slight differences
  // in input data
  // producing large differences
  // in output data.

  // we has the 8 unit cube coordinates
  // which surround the input coordinates
  int A = p[X]+Y;
  int AA = p[A]+Z;
  int AB = p[A+1]+Z;
  int B = p[X+1]+Y;
  int BA = p[B]+Z;
  int BB = p[B+1]+Z;

  // we roll our own linear interpolation that is different from the library lerp();
  // 
  return lerp2(w, lerp2(v, lerp2(u, grad(p[AA], x, y, z), grad(p[BA], x-1, y, z)), 
    lerp2(u, grad(p[AB], x, y-1, z), grad(p[BB], x-1, y-1, z))), 
    lerp2(v, lerp2(u, grad(p[AA+1], x, y, z-1), grad(p[BA+1], x-1, y, z-1)), 
    lerp2(u, grad(p[AB+1], x, y-1, z-1), grad(p[BB+1], x-1, y-1, z-1))));
}

//================================================================

// also known as an ease curve, creates smooth transitions between gradients
float fade(float t) { 

  //6*t^5 - 15*t^4 + 10*t^3
  // it 'eases' values towards integral curves
  // smooths final output
  return ((t*6 - 15)*t + 10)*t*t*t;
}

//================================================================

// we linear interpolate to output a weighted average based on fade(u,v,w)
float lerp2(float t, float a, float b) { 
  return (b - a)*t + a;
}

//================================================================


// we calculate the dot product
// of randomly selected gradient vectors
// and 8 location vectors
// we use some elegant bitflipping to achieve this
float grad(int hash, float x, float y, float z) {

  // this is alternative to ken perlin's original dot product formula
  // this runs faster
  // its longer but reads more simply
  // either algorithm selects random vector from:
  // [(1,1,0),(-1,1,0),(1,-1,0),(-1,-1,0),
  // (1,0,1),(-1,0,1),(1,0,-1),(-1,0,-1),
  // (0,1,1),(0,-1,1),(0,1,-1),(0,-1,-1)]
  switch(hash & 0xF)
  {
  case 0x0: 
    return  x + y;
  case 0x1: 
    return -x + y;
  case 0x2: 
    return  x - y;
  case 0x3: 
    return -x - y;
  case 0x4: 
    return  x + z;
  case 0x5: 
    return -x + z;
  case 0x6: 
    return  x - z;
  case 0x7: 
    return -x - z;
  case 0x8: 
    return  y + z;
  case 0x9: 
    return -y + z;
  case 0xA: 
    return  y - z;
  case 0xB: 
    return -y - z;
  case 0xC: 
    return  y + x;
  case 0xD: 
    return -y + z;
  case 0xE: 
    return  y - x;
  case 0xF: 
    return -y - z;
  default: 
    return 0; // never happens

    // this is the dot production calculation function using bitwise operation
    /*
      int h = hash & 15;
     float u = h<8 ? x : y;
     float v = h<4 ? y : h==12||h==14 ? x : z;
     return ((h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
     */
  }
}
//================================================================
// hash lookup table defined by Ken Perlin.

// array of all numbers is 255 inclusive
void setupPermutationTable() {
  int permutation[] = { 151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 
    233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 
    6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 
    11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 
    68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 
    229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 
    143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 
    169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 
    3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 
    85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 
    170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 
    43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 
    185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 
    191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 
    31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 
    254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 
    66, 215, 61, 156, 180 };

  // repeat this array twice to avoid overflow
  p = new int[512];
  for (int i=0; i < 256; i++)
    p[i] = p[i+256] = permutation[i];
}
