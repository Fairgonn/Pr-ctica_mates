
//CORAZONES
PImage Hearth;
boolean firstHearth;
boolean secondHearth;

//OBSTÁCULOS (THE ROCK)
PImage[] LaRoca = new PImage[8];
float[] TheRockX = new float[8];
float[] TheRockY = new float[8];
int RockSizeX = 80;
int RockSizeY = 50;

//ITEMS
float[] itemX = new float[3];
float[] itemY = new float[3];

//TELEPORT
float TeleportX;
float TeleportY;
float LargoTeleport;
float AltoTeleport;

//Fondo final
PImage Namek;

//MECANICA DEL JUEGO

boolean firstHealth;
boolean secondHealth;

boolean GameOver;
boolean gamePaused = false;
float radio;
float counter;
int miliseconds;
int finalSeconds;
long tiempo_inicial = 0;
int espera = 2000;
int d = 0;
boolean FinalFight;
boolean collide;
boolean done = true;
boolean nextToMe;
boolean following = false;
float distanciaPJ2;

//POSICIONES DE LOS PNJS
float[] xPNJ = new float[9];
float[] yPNJ = new float[9];
float[] ALFA = new float[9];

//ITEMS
float[] ItemX = new float[3];
float[] ItemY = new float[3];
boolean NoItem1, NoItem2, NoItem3;

//FINAL BOSS
PImage Freezer;

boolean winFinalBoss;
float xBoss, yBoss;
float medidaXboss, medidaYboss;
float bossSpeed;
float[] rposx = new float[4];
float[] rposy = new float[4];
int timeFinalFight;


//PARTÍCULAS FINALES (SI EL FINAL BOSS FINALMENTE EXPLOTA)
int size = 20;
PVector[] pos;
PVector[] vel;
PVector[] ac;
PVector[] f;
float[] m;
float deltaT;


// SETUP
void setup() {

  size(1366, 768);

  NoItem1 = false;

  TeleportX = random(30.0, width / 3.0);
  TeleportY = random(0.0, height - 30.0);
  LargoTeleport = 15.0;
  AltoTeleport = 60.0;

  firstHealth = true;
  secondHealth = false;

  GameOver = false;

  for (int i = 0; i < 3; i++)
  {
    ItemX[i] = random(30.0, width - 30.0);
    ItemY[i] = random(30.0, height - 30.0);
  }

  for (int i = 0; i < 8; i++)
  {
    LaRoca[i] = loadImage("roka.jpeg");
    LaRoca[i].resize(RockSizeX, RockSizeY);

    TheRockX[i] = random (30.0, width - 30.0);
    TheRockY[i] = random (30.0, height - 30.0);

    image(LaRoca[i], TheRockX[i], TheRockY[i]);
  }

  Namek = loadImage("Namek.jpg");
  Namek.resize(1366, 768);

  Freezer = loadImage("frieza.jpg");

  radio = 10.0;
  firstHearth = true;
  secondHearth = false;
  Hearth = loadImage("corasonsito.png");
  Hearth.resize(40, 40);





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
  counter = 25.0;
  miliseconds = 1000;

  nextToMe = false;
  collide = false;

  //DECIMOS QUE AL EMPEZAR EL JUEGO, ESTE AÚN NO HA TERMINADO
  FinalFight = false;

  //ALFA 0 VA A SER EL PJ2

  //ALFA 1 - 4 VAN A SER LOS QUE VAN A HUIR DEL PJ2

  //ALFA 5 - 9 VAN A SER LOS QUE VAYAN A POR EL PJ1
  for (int i = 0; i < 9; i++)
  {
    if ( i < 5 )
    {
      ALFA[i] = random(0.0015, 0.004);
    } else
    {
      ALFA[i] = random(0.03, 0.06);
    }
  }

  //BOSS
  xBoss = random(width / 2.0, width);
  yBoss = random(0, height);
  winFinalBoss = false;
  medidaXboss = 225.0;
  medidaYboss = 225.0;
  bossSpeed = 0.025;
  timeFinalFight = 15;
  finalSeconds = 0;

  Freezer.resize(225, 225);
  image(Freezer, xBoss, yBoss);

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

  distanciaPJ2 = dist (mouseX, mouseY, xPNJ[0], yPNJ[0]); // distancia PJ1 a PJ2
  follows(distanciaPJ2);
  
  if (GameOver)
  {
    background(0);

    textSize(70);
    fill(255, 0, 0);
    text("GAME OVER! YOU LOSE!", 335.0, height / 2.0);
  }

  if (counter <= 0 && firstHealth == true && secondHealth == false)
  {
    GameOver = true;
  }

  if (counter <= 0 && firstHealth == true && secondHealth == true)
  {
    secondHealth = false;
    counter = 15;
  }

  if (!GameOver)
  {

    for (int i = 0; i < 3; i++)
    {
      fill(0, 0, 255);

      if (!NoItem1)
      {
        square(ItemX[0], ItemY[0], 30.0);
      }

      if (!NoItem2)
      {
        square(ItemX[1], ItemY[1], 30.0);
      }

      if (!NoItem3)
      {
        square(ItemX[2], ItemY[2], 30.0);
      }

      if (mouseX + radio > ItemX[i] && mouseY + radio > ItemY[i] && ItemX[i] + 30.0 > mouseX - radio && ItemY[i] + 30.0 > mouseY - radio)
      {
        collide = true;


        if (collide == true && i == 0)
        {
          for (int j = 5; j < 9; j++)
          {
            ALFA[j] = ALFA[j] * 2;
            NoItem1 = true;
          }
        }

        if (collide == true && i == 1)
        {
          for (int k = 5; k < 9; k++)
          {
            ALFA[k] = ALFA[k] / 2;
            NoItem2 = true;
          }
        }

        if (collide == true && i == 2)
        {
          secondHealth = true;
          NoItem3 = true;
        }
      }
    }

    if (NoItem1 && NoItem2 && NoItem3)
    {

      fill(random(0, 255), random(0, 255), random(0, 255));
      rect(TeleportX, TeleportY, LargoTeleport, AltoTeleport);

      textSize(20);
      fill(0, 255, 0);
      text("A PORTAL!", TeleportX - 35.0, TeleportY - 20.0);

      if (mouseX + radio > TeleportX && mouseY + radio > TeleportY && TeleportX + LargoTeleport > mouseX - radio && TeleportY + AltoTeleport > mouseY - radio)
      {
        FinalFight = true;
      }
    }

    for (int i = 0; i < 8; i++)
    {
      image(LaRoca[i], TheRockX[i], TheRockY[i]);

      if (mouseX + radio > TheRockX[i] && mouseY + radio > TheRockY[i] && TheRockX[i] + RockSizeX > mouseX - radio && TheRockY[i] + RockSizeY > mouseY - radio)
      {
        if (!secondHealth)
        {
          GameOver = true;
        }

        if (secondHealth)
        {
          secondHealth = false;
        }
      }
    }

    if (firstHealth)
    {
      image(Hearth, 20, 20);
    }

    if (secondHealth)
    {
      image(Hearth, 70, 20);
    }


    if (!FinalFight)
    {
      wait(espera);
      if (tiempo_inicial >= espera)
      {
        for (int i = 0; i < 4; i++)
        {
          rposx[i] = random(10.0, width - 10.0);
          rposy[i] = random(10.0, height - 10.0);
        }
        espera += 1000;
      }

      for (int i = 0; i < 9; i++)
      {
        if ( i == 0)
        {
          if (following)
          {
            xPNJ[i] = xPNJ[i] + 0.15 * (mouseX - xPNJ[i]);
            yPNJ[i] = yPNJ[i] + 0.15 * (mouseY - yPNJ[i]);
          } else
          {
            xPNJ[i] = xPNJ[i];
            yPNJ[i] = yPNJ[i];
          }
        } else if ( i < 5 ) //Primeros 4 PNJs hacen wander
        {
          xPNJ[i] = xPNJ[i] + ALFA[i] * (rposx[d] - xPNJ[i]);
          yPNJ[i] = yPNJ[i] + ALFA[i] * (rposy[d] - yPNJ[i]);
        } else // La resta persigue al PJ2 y huyen de PJ1
        {
          xPNJ[i] = xPNJ[i] + ALFA[i] * (xPNJ[0] - xPNJ[i]);
          yPNJ[i] = yPNJ[i] + ALFA[i] * (xPNJ[0] - yPNJ[i]);
          xPNJ[i] = xPNJ[i] - ALFA[i] * (xPNJ[0] - xPNJ[i]);
          yPNJ[i] = yPNJ[i] + ALFA[i] * (yPNJ[0] - yPNJ[i]);
        }
        d++;
        if ( d == 4 )
        {
          d = 0;
        }
      }


      fill(0); // El PJ es verde
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
      text("REMAINING TIME: " + (int)counter, width - 275.0, 30.0);

      wait(miliseconds);
    }
  }

  if (FinalFight)
  {

    background(Namek);



    if (!winFinalBoss)
    {

      fill(0);
      ellipse(mouseX, mouseY, 20.0, 20.0);

      image(Freezer, xBoss, yBoss);

      xBoss = xBoss + bossSpeed *((mouseX - medidaXboss / 2.0) - xBoss);
      yBoss = yBoss + bossSpeed *((mouseY - medidaXboss / 2.0) - yBoss);


      textSize(30);
      fill(0);
      text("IT'S FRIEZA! SURVIVE, HE'S AT 100% STRENGHT!!", width / 2.0 - 325.0, 50.0);

      if (mouseX + radio > xBoss && mouseY + radio > yBoss && xBoss + medidaXboss > mouseX - radio && yBoss + medidaYboss > mouseY - radio)
      {
        GameOver = true;
      }

      if (millis() > miliseconds + 1000)
      {
        miliseconds += 1000;
        timeFinalFight--;

        if (timeFinalFight <= 0)
        {
          winFinalBoss = true;
        }
      }
    }

    if (timeFinalFight <= 0)
    {
      reposition(pos);
      solverEuler();
      for (int i = 0; i < size; i++)
      {
        fill(random(100, 150), random(0, 20), random(0, 20));
        ellipse(pos[i].x, pos[i].y, m[i] * 15.0, m[i] * 15.0);
      }
      fill(0);
      ellipse(mouseX, mouseY, 20.0, 20.0);

      textSize(30);
      fill(255, 0, 0);
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
    counter--;
  }
}





void reposition(PVector pos[])
{
  if (done)
  {
    for (int i = 0; i < size; i++)
    {
      pos[i] = new PVector(xBoss + medidaXboss / 2.0, yBoss + medidaYboss / 2.0);
    }
  }
  done = false;
}


void follows (float distanciaPJ2)
{
  if ( distanciaPJ2 < 100.0 )
  {
    println("Entré");
    following = true;
  }
}
