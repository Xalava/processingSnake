  int leScore = 0;
  int dirX = -1;
  int dirY = 0;
  int taille = 3;
  
  anneau[] serpent;
                     
  boolean isPomme = false;
  boolean isPommeIce = false;

  int pommeX;
  int pommeY;
  
  int state=0;
  
  //Coefficient grid
  int k = 20;
  PImage imgPomme;
  PImage imgPommeIce;

  PFont zigBlack;
  
  int vitesse;

void setup() {
  size(620, 620);
   frameRate(7);

   imgPomme = loadImage("pomme.png");
  zigBlack = createFont("Ziggurat-Black",50);
  imgPommeIce = loadImage("pommeIce.png");
   menu();
}


void draw() {
  //state O: menu 1 game over, 2 game débutant 3 game avancé
  if ( state == 0){
      background(0,40,0);
       menu();
  } else if (state == 1){
      fill(255,0,0);
      textSize(50);
      textAlign(CENTER);
      textFont(zigBlack);
      text("GAME OVER", 310,100);
      menu();
  } else {
  
  
 
  background(10);
  
  affichageText();
  if (! isPomme) {
     nouvellePomme();
  } 
  
  //redessiner pomme

   if(!isPommeIce){
      image(imgPomme, pommeX*k-15, pommeY*k-15);
   } else {
     image(imgPommeIce, pommeX*k-15, pommeY*k-15);
   }
  
  collectDirection();
  //prochain point
  int futurX= serpent[0].x+dirX;
  int futurY= serpent[0].y+dirY;
  
  
  switch(checkCollision(futurX,futurY)) {
  // 0 aucune, 1 self/paroie, 2 pomme
    case 0:
      //Décalage de tableau
      for (int j = taille-1; j > 0; j--) {
        serpent[j] = serpent[j-1];
      }     
      break;
    case 1:
      // game over
      state =1;
;
      break;
    case 2:
      leScore = leScore+taille;
      taille = taille+1;
      serpent= (anneau[])expand(serpent,taille);
      //append(serpent, new anneau(serpent[taille-1].x,serpent[taille-1].y));

      isPomme = false;
      if (isPommeIce) {
         vitesse=vitesse+10;
         frameRate(vitesse);
         isPommeIce=false;
      }
       
      for (int j = taille-1; j > 0; j--) {
        serpent[j] = serpent[j-1];
      }  
      break;
    default:             
      println("error");   
      break;
    }// fin switch
   
    println(serpent.length);
 
   //ajout nouvelle tete
    serpent[0] = new anneau (futurX,futurY);
    
    
   //dessinerSerpent
   for (int j = 0; j < taille; j++) {
      serpent[j].display(j);
   }
  }   // fin cas initiaux
}



void affichageText(){
  
 textAlign(LEFT);
 textSize(25);
 fill(200,200,0);
 text(leScore, 5,25);
   //text("Da Snake ", 340, 380); 
     //text(KeyCode, 40, 380); 

}


void menu(){
  
    fill(50);
    // case partie débutant
    rect(210,200,200,50);
    // partie rapide
    rect(210,300,200,50);
    // quitter
    rect(210,400,200,50);

    fill(255);
    textAlign(CENTER);
    textSize(35);
    text("Da Snake ", 310,140);
    textSize(25);
    text("Partie débutant", 310,235);

    text("Partie avancé", 310,335);
    
    text("Quitter", 310,435);
    
    
    
 //<>//
  

   
   
   if (mousePressed == true){
     if ((mouseX >= 210) && (mouseX <= 410)){
        if ((mouseY >= 200) && (mouseY <= 250)) {
          //partie lente
          state=2;
          vitesse=7;
          initJeu();
          
  
        } else if ((mouseY >= 300) && (mouseY <= 350)) {
          //partie avancée
         state=3;
         vitesse=10;
         initJeu();
         
        } else if ((mouseY >= 400) && (mouseY <= 450)) {
            //quitter
           exit();

       }  
     }
   }
    

}

  void initJeu(){
    
    frameRate(vitesse);
    taille=3;
    serpent = new anneau[taille];
    for (int i = 0; i < taille; i++) {
      serpent[i] = new anneau(15+i,15);
    } 
    
    isPomme= false;
  
}


void collectDirection(){
   
  if (key == CODED) { 
    if (keyCode == UP) {
      if ( dirY != 1){
        dirY = -1;
        dirX=0;
      }

    } else if (keyCode == DOWN) {
       if ( dirY != -1){
        dirY = 1;
        dirX=0;
      }

    } else if (keyCode == LEFT) {
      if ( dirX != 1){
        dirY = 0;
        dirX= -1;
      }
    } else if (keyCode == RIGHT) {
      
      if ( dirX != -1){
        dirY = 0;
        dirX= 1;
      }
    }
  } 
  
}



  void nouvellePomme(){
    // Pomme à pommeX, PommeY
    
    int futurPommeX = int(random(1,30));    
    int futurPommeY = int(random(1,30));
    
    //tester si la pomme ne tombe pas sur le serpent
    for (int j = 0; j < taille; j++) {
      if (serpent[j].selfCollision(futurPommeX,futurPommeY)){
        return ;
      }
    }
    
    if ((state==3)&&(random(0,10)>9)){
      isPommeIce=true;
    }
    
    // pomme démarrée
    pommeX=futurPommeX;
    pommeY=futurPommeY;
    isPomme = true;
    
  }

int checkCollision(int futurX,int futurY){
    // return 1 quand collision
   for (int j = 0; j < taille; j++) {
      if (serpent[j].selfCollision(futurX,futurY)){
        return 1;
      }
   }
   
   if ((futurX==0)||(futurY==0)||(futurX==31)||(futurY==31)){
     return 1;
   }
   
   // si pomme
   if ((futurX==pommeX) && (pommeY==futurY)){

     return 2;

   }
    
    return 0;
    
 }

  
  class anneau {

  int x,y;   // x et y de 1 à 20
  // Cell Constructor
  anneau(int tempX, int tempY) {
    x = tempX;
    y = tempY;
  } 
  
  void display(int i) {

    fill(0,100+155/(i+1),0);
    noStroke();
    int diam = max(200/(i+10),5);
    ellipse(x*k,y*k,diam,diam); 
  }
  
  boolean selfCollision(int futurX, int futurY){
    if ((futurX==x)&&(futurY==y)){
      return true;
    } else {
      return false;
    }
  }
}