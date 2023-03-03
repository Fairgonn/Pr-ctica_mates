// práctica mates aa1






// VARIABLES
int vidas;
float counter;
int finalSeconds;

boolean gameOver;
boolean collide;

float[] randomX = new float[4];
float[] randomY = new float[4];

float[] xPNJs = new float[9];
float[] yPNJs = new float[9];
float[] ALFAs = new float[9];

float[] xObject = new float[8];
float[] yObject = new float[8];

boolean exists;
boolean winFinalBoss;
float xBoss;
float yBoss;
float medidaXboss;
float medidaYboss;
float bossSpeed;








// SETUP
void setup() {
  
  size(1366, 768);
  
  for (int i = 0; i < 9; i++) {
    
        xPNJs[i]=random(0, width);
        yPNJs[i]=random(0, height);
  }
  //INICIALIZAMOS EL CONTADOR A 20 SEGUNDOS
  counter = 5;
  
  //DECIMOS QUE AL EMPEZAR EL JUEGO, ESTE AÚN NO HA TERMINADO
  gameOver = false;
  
  //ALFA 0 VA A SER EL PJ2
  ALFAs[0]=0.0;
  
  //ALFA 1 - 4 VAN A SER LOS QUE VAN A HUIR DEL PJ2
  ALFAs[1]=0.0;
  ALFAs[2]=0.0;
  ALFAs[3]=0.0;
  ALFAs[4]=0.0;
  
  //ALFA 5 - 9 VAN A SER LOS QUE VAYAN A POR EL PJ1
 for(int i = 0; i < 9; i++)
 {
   if(i > 5)
   {
     ALFAs[i] = random(0.005, 0.06); 
   }
 }
  
  //BOSS
   xBoss = random(width / 2.0, width);
   yBoss = random(0, height);
   exists = true;
   winFinalBoss = false;
   medidaXboss = 35.0;
   medidaYboss = 35.0;
   bossSpeed = 0.08;
   finalSeconds = 0;
}







// DRAW
void draw() {

background(255);
  // 1. Calcular
  
  
if (gameOver == false)
{
    for (int i = 0; i < 9; i++)
    {
        if ((xPNJs[i] > 10.0) && (xPNJs[i] < width - 10.0) && (yPNJs[i] > 10.0) && (yPNJs[i] < height - 10.0))
        {
          // PNJ está dentro de la ventana
          xPNJs[i]=xPNJs[i]+ALFAs[i]*(mouseX - xPNJs[i]);
          yPNJs[i]=yPNJs[i]+ALFAs[i]*(mouseY - yPNJs[i]);
        } 
    
        else 
        {
          // Te saliste
          xPNJs[i]= width/2.0;
          yPNJs[i]= height/2.0;
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
      fill(0, 255, 0); // El PNJ es rojo
      ellipse(xPNJs[i], yPNJs[i], 20.0, 20.0);
    }
    
    else if (i != 0)
    {
      fill(255, 0, 0); // El PNJ es rojo
      ellipse(xPNJs[i], yPNJs[i], 20.0, 20.0);
    }
  }
  
  textSize(30);
  fill(0);
  text("REMAINING TIME: " + counter, width - 300.0, 30.0);
  millis(); //COMO USARLO CORRECTAMENTE??
  counter -= 0.0155;
  
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
    
    
    if (exists)
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
    
    if(medidaXboss >= 250 && medidaYboss >= 250)
    {
      winFinalBoss = true;
      exists = false;
    }
    
    }
    
    if (winFinalBoss)
    {
      fill(0, 150, 0);
      ellipse(mouseX, mouseY, 20.0, 20.0);
      
      textSize(30);
      fill(0,0,255);
      text("HE COULDN'T STORE ALL THAT WEIGHT...", width / 2.0 - 270.0, 300.0);
      text("THANK YOU FOR SAVING US!", width / 2.0 - 200.0, 350.0);
      
      millis();
        finalSeconds += 1;
        
       if (finalSeconds >= 300)
       {
         background(0);
         
          textSize(70);
          fill(0,255,0);
          text("GAME OVER! YOU WIN!", 335.0, height / 2.0); 
       }
    }
    
  }
  
  
  
}
