// PROGRAMANDO PATH FINDING
// 4 PNJs
// ECUACION PARAMETRICA RECTA
// RECTA(ALFA) = ALFA*PJ + (1-ALFA)*PNJ
// RECTA(ALFA) = PNJ+ALFA*vector = PNJ+ALFA*(PJ-PNJ)

// VARIABLES
int vidas;
float counter;
int finalSeconds;
long tiempo_inicial = 0;
int espera = 2000;
int d = 0;
boolean gameOver;
boolean collide;
boolean done = true;

float[] xPNJ = new float[9];
float[] yPNJ = new float[9];
float[] ALFA = new float[9];

float[] xObject = new float[8];
float[] yObject = new float[8];

boolean winFinalBoss;
float xBoss;
float yBoss;
float medidaXboss;
float medidaYboss;
float bossSpeed;
float[] rposx = new float[4];
float[] rposy = new float[4];

// Variables partículas
int size = 10;
PVector[] pos;
PVector[] vel;
PVector[] ac;
PVector[] f;
float[] m;
float deltaT;


// SETUP
void setup() {

  size(1366, 768);

  for (int i=0; i < 9; i++) {

    xPNJ[i]=random(0, width);
    yPNJ[i]=random(0, height);
  }

  // Inicializamos las partículas
  pos = new PVector[size];
  vel = new PVector[size];
  ac = new PVector[size];
  f = new PVector[size];
  m = new float[size];

  //INICIALIZAMOS EL CONTADOR A 20 SEGUNDOS
  counter = 20.0;

  //DECIMOS QUE AL EMPEZAR EL JUEGO, ESTE AÚN NO HA TERMINADO
  gameOver = false;

  //ALFA 0 VA A SER EL PJ2

  //ALFA 1 - 4 VAN A SER LOS QUE VAN A HUIR DEL PJ2

  //ALFA 5 - 9 VAN A SER LOS QUE VAYAN A POR EL PJ1
  for (int i = 0; i < 9; i++)
  {
    if ( i < 5 )
    {
      ALFA[i] = 0.001;
    } else
    {
      ALFA[i] = random(0.005, 0.06);
    }
  }

  //BOSS
  xBoss = random(width / 2.0, width);
  yBoss = random(0, height);
  winFinalBoss = false;
  medidaXboss = 35.0;
  medidaYboss = 35.0;
  bossSpeed = 0.08;
  finalSeconds = 0;

  for (int i = 0; i < size; i++)
  {
    pos[i] = new PVector(xBoss, yBoss);
    vel[i] = new PVector(random(10.0, 50.0), random(5.0, 60.0));
    ac[i] = new PVector(0.0, 0.0);
    f[i] = new PVector(0.0, 0.0);
    m[i] = random(0.5, 5.0);
  }

  deltaT = 0.04f;
}




// DRAW
void draw() {

  background(255);
  // 1. Calcular


  if (!gameOver)
  {
    wait(espera);
    if (tiempo_inicial >= espera)
    {
      for (int i = 0; i < 4; i++)
      {
        rposx[i] = random(10.0, width - 10.0);
        rposy[i] = random(10.0, height - 10.0);
      }
      espera += 2000;
    }
    for (int i = 0; i < 9; i++)
    {
      if ( i == 0)
      {
        xPNJ[i] = xPNJ[i];
        yPNJ[i] = yPNJ[i];
      } else if ( i < 5 ) // Primeros 4 PNJs hacen wander
      {
        xPNJ[i] = xPNJ[i] + (ALFA[i] * (rposx[d] - xPNJ[i]));
        yPNJ[i] = yPNJ[i] + (ALFA[i] * (rposy[d] - yPNJ[i]));
      } else // La resta persigue al PJ1
      {
        xPNJ[i] = xPNJ[i] + ALFA[i] * (mouseX - xPNJ[i]);
        yPNJ[i] = yPNJ[i] + ALFA[i] * (mouseY - yPNJ[i]);
      }
      d++;
      if ( d == 4 )
      {
        d = 0;
      }
    }

    // 2. Pintar

    // El PJ
    fill(0, 150, 0); // El PJ es verde
    ellipse(mouseX, mouseY, 20.0, 20.0);

    // Los PNJs
    for (int i = 0; i < 9; i++)
    {
      if (i == 0)
      {
        fill(0, 255, 0); // El PJ2 es verde
        ellipse(xPNJ[i], yPNJ[i], 20.0, 20.0);
      } else if (i > 0)
      {
        fill(255, 0, 0); // El PNJ es rojo
        ellipse(xPNJ[i], yPNJ[i], 20.0, 20.0);
      }
    }

    textSize(30);
    fill(0);
    text("REMAINING TIME: " + counter, width - 300.0, 30.0);
    counter -= 0.016;

    if (counter <= 0)
    {
      gameOver = true;
    }
  }

  if (gameOver)
  {

    /*background(0);
     
     textSize(70);
     fill(255,0,0);
     text("GAME OVER! YOU LOSE!", 335.0, height / 2.0);*/

    //PROBAR A IMPLEMENTAR EL FINAL BOSS
    background(150);


    if (!winFinalBoss)
    {

      fill(0, 150, 0); // El PJ es verde
      ellipse(mouseX, mouseY, 20.0, 20.0);

      fill(150, 0, 0);
      ellipse(xBoss, yBoss, medidaXboss, medidaYboss);

      xBoss = xBoss + bossSpeed *(mouseX - xBoss);
      yBoss = yBoss + bossSpeed *(mouseY - yBoss);

      millis();
      medidaXboss += 0.2;
      medidaYboss += 0.2;

      textSize(30);
      fill(0);
      text("IT'S THE BOSS! SURVIVE, HE'S ENORMOUS!!", width / 2.0 - 300.0, 50.0);

      if (medidaXboss >= 250 && medidaYboss >= 250)
      {
        winFinalBoss = true;
      }
    }

    if (winFinalBoss)
    {
      reposition(pos);
      solverEuler();
      for (int i = 0; i < size; i++)
      {
        fill(random(100, 150), random(0, 20), random(0, 20));
        ellipse(pos[i].x, pos[i].y, m[i] * 15.0, m[i] * 15.0);
      }
      fill(0, 150, 0);
      ellipse(mouseX, mouseY, 20.0, 20.0);

      textSize(30);
      fill(0, 0, 255);
      text("HE COULDN'T STORE ALL THAT WEIGHT...", width / 2.0 - 270.0, 300.0);
      text("THANK YOU FOR SAVING US!", width / 2.0 - 200.0, 350.0);

      millis();
      finalSeconds += 1;

      if (finalSeconds >= 300)
      {
        background(0);

        textSize(70);
        fill(0, 255, 0);
        text("GAME OVER! YOU WIN!", 335.0, height / 2.0);
      }
    }
  }
}

void solverEuler()
{
  // 1) Aceleracion = Fuerza / masa
  // 2) Nueva velocidad = Vel ant. + Aceleracion * DT
  // 3) Nueva posicion = Posicion ant. + (vel.ant. * DT)
  for (int i = 0; i < size; i++)
  {
    f[i].x = 0.0;
    f[i].y = 0.0;
    f[i].x = 0.0;
    f[i].y = 9.8;
    ac[i].x = f[i].x / m[i];
    ac[i].y = f[i].y / m[i];
    vel[i].x = vel[i].x + ac[i].x * deltaT;
    vel[i].y = vel[i].y + ac[i].y * deltaT;
    pos[i].x = pos[i].x + vel[i].x * deltaT;
    pos[i].y = pos[i].y + vel[i].y * deltaT;
  }
}

void wait (int t)
{
  if (millis() >= tiempo_inicial + t)
  {
    tiempo_inicial = millis();
  }
}

void reposition(PVector pos[])
{
  if (done)
  {
    for (int i = 0; i < size; i++)
    {
      pos[i] = new PVector(xBoss, yBoss);
    }
  }
  done = false;
}
