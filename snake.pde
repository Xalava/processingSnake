  int leScore ;
  int dirX;
  int dirY ;
  int taille ;
  
  int futurX;
  int futurY;
  
    int futurXghost;
  int futurYghost;
  anneau[] serpent;
  anneau[] serpentBis;
  
  boolean isPomme ;
  boolean isPommeIce ;
  boolean isPommeGhost ;
  
  boolean modeGhost;
  
  int pommeX;
  int pommeY;
  
  obstacle[] obstacles;
  int nbObstacles;
  int compteurRelou;
  
  int state=0;
  
  //Coefficient grid
  int k = 20;
  PImage imgPomme;
  PImage imgPommeIce;
  PImage imgPommeGhost;
  PImage imgInformation;

  PFont zigBlack;
  int vitesse;
  
  int modeSpeed;
  int timerObstacle;

  int alter;
void setup() {
  size(620, 620);
   
  imgPomme = loadImage("pomme.png");
  zigBlack = createFont("Ziggurat-Black",50);
  imgPommeIce = loadImage("pommeIce.png");
  imgPommeGhost = loadImage("pommeGhost.png");
  imgInformation = loadImage("information.png");
}

void draw() {
  //state 
  //-1 informationO menu initial 1 game over, 2 game débutant 3 game avancé
  if (state==-1){
    affichageInformation();
  }else if ( state == 0){
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
  
  
   if (modeSpeed==0) {
        background(10);
     } else {
         switch (alter){
          case 0:
            background(140,10,10);
            alter++;
            break;
          case 1:
            background(10,10,140);
            alter++;
            break;
          case 2:
            alter++;
            background(10);
            break;
       default:
         alter=0;
         background(10);
     }// fin switch
  }// fin background

  
  if(state==3){
    if(modeSpeed>0){
      modeSpeed--;
    } else {
      vitesse=12;
      frameRate(vitesse);
    }
    
    if(compteurRelou>0){
      compteurRelou--;
    }
    
  }
  
  affichageText();
  if (! isPomme) {
     nouvellePomme();
  } 
  affichagePomme();
  //redessiner pomme

  
   // redessiner obstacle
   
       for (int i = 0; i < nbObstacles; i++) {
        obstacles[i].display();
      } 
   
  
  collectDirection();
  //prochain point
  futurX= serpent[0].x+dirX;
    futurX= recalage(futurX);
  futurY= serpent[0].y+dirY;
    futurY = recalage(futurY);
    
  //if ghost mode: futur
   collectObstacle();
 
  
  switch(checkCollision(futurX,futurY)) {
  // 0 aucune, 1 self/paroie, 2 pomme
    case 0:
      // cas rien
      //Décalage de tableau
      for (int j = taille-1; j > 0; j--) {
        serpent[j] = serpent[j-1];
      }     
      break;
    case 1:
      // cas self, obstacle game over
      state =1;
;
      break;
    case 2:
    // cas pomme
    effetPomme(futurX,futurY);
    mangerPomme(); 
    
      break;
    default:             
      println("error");   
      break;
    }// fin switch
    //<>//
    println(serpent.length);
 
   //ajout nouvelle tete
    serpent[0] = new anneau (futurX,futurY);
    
    
   //dessinerSerpent
   for (int j = 0; j < taille; j++) {
      serpent[j].display(j);
   }
   
  }   // fin cas initiaux
  
  
   if(modeGhost){
      futurXghost= recalage(serpentBis[0].x+dirX);
      futurYghost= recalage(serpentBis[0].y+dirY); 
             
      switch(checkCollision(futurXghost,futurYghost)) {
      // 0 aucune, 1 self/paroie, 2 pomme
      case 0:
        // cas rien
        //Décalage de tableau
        for (int j = taille-1; j > 0; j--) {
          serpentBis[j] = serpentBis[j-1];
        }     
        break;
      case 1:
        // cas self, obstacle, remove ghost
        modeGhost= false;
        break;
        
      case 2:
      // cas pomme
      effetPomme(futurXghost,futurYghost);
      mangerPomme(); 
        break;
      default:             
        println("error");   
        break;
      }// fin switch

     //ajout nouvelle tete
      serpentBis[0] = new anneau (futurXghost,futurYghost);
    
      for (int j = 0; j < taille; j++) {
      serpentBis[j].displayGhost(j);
       }

  } // fin si modeGhost
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  checkInformation();
}

void mangerPomme(){
      leScore = leScore+int(taille*vitesse/30);
      taille = taille+1;
      serpent= (anneau[])expand(serpent,taille);
      
      for (int j = taille-1; j > 0; j--) {
        serpent[j] = serpent[j-1];
      }  
      
      if(modeGhost){
             serpentBis= (anneau[])expand(serpentBis,taille);
      
      for (int j = taille-1; j > 0; j--) {
        serpentBis[j] = serpentBis[j-1];
      }  
       
      }
      
      

      isPomme = false;
      
      if (isPommeIce) {
         vitesse=vitesse+15;
         modeSpeed=129;
         frameRate(vitesse);
         isPommeIce=false;

      } else if(isPommeGhost){
          //effet manger Pomme Ghost
    
        //taille= int(taille/2);
        serpentBis = new anneau[taille];
        for (int m = 0; m < taille; m++) {
          serpentBis[m] = new anneau(recalage(serpent[m].x+3),recalage(serpent[m].y+3));
        } 
        modeGhost=true;
        isPommeGhost=false;
      }
}




void checkInformation(){
    if (mousePressed == true){
     if ((mouseX >= 600) && (mouseY >= 600)) {
         state=-1;
     }
    }


  
}

void affichagePomme(){
  
    if(isPommeIce){
      image(imgPommeIce, pommeX*k-15, pommeY*k-15);
   } else if(isPommeGhost){
       image(imgPommeGhost, pommeX*k-15, pommeY*k-15);
   } else {
     image(imgPomme, pommeX*k-15, pommeY*k-15);
   } 
}

void affichageInformation(){
  //rect cadre
  
  fill(30,30,30);
  rect(110,110,400,400);
  
  //rect bouton retour
   fill(50);
   rect(210,460,200,30);
  
  fill(200,200,200);
  textSize(12);
  int align= 180;
    textAlign(LEFT);
    image(imgPomme,align, 160);
    text("Agrandit le serpent snake d'une case",align+40,180);
    
    image(imgPommeIce, align, 260);
    text("Mode Cobra pour 10 secondes",align+40,280);
    
    image(imgPommeGhost, align, 360);
    text("Double le serpent d'un fantome jusqu'à sa mort",align+40,380);
   
    textAlign(CENTER);
    text("Retour",310,480);
    
    
        if (mousePressed == true){
     if ((mouseX >= align) && (mouseY >= 460)) {
         state=3;
     }
    }

}



void affichageText(){
  
 textAlign(LEFT);
 textSize(25);
 fill(200,200,0);
 text(leScore, 5,25);
   //text("Da Snake ", 340, 380); 
     //text(KeyCode, 40, 380); 
textSize(10);
  if (modeSpeed>0){
    fill(200,0,0);
    textSize(22);
   text("Mode Cobra",5,590);
   text(modeSpeed, 170,590);
  }
  
  if (state==3){
   fill(0,0,255);
   textSize(14);
     if (compteurRelou>0){
       text("Obstacle dans",490,13);
       text(int(compteurRelou/10), 589,13);
     }else {
       text("Obstacle à déposer avec la souris",350,13);
     }
    
    image(imgInformation,588, 588);

  }
  
 fill(200,200,0);
 textSize(10);
 text("vitesse", 512,590);
 text(vitesse, 552,590);
 


}

int recalage(int var){
   if (var>=31){
      return var-30;
    } else if(var<=0){
      return var+30;
    } else {
      return var;
    }
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
   
   if (mousePressed == true){
     if ((mouseX >= 210) && (mouseX <= 410)){
        if ((mouseY >= 200) && (mouseY <= 250)) {
          //partie lente

          initJeu(2);
          
  
        } else if ((mouseY >= 300) && (mouseY <= 350)) {
          //partie avancée
         initJeu(3);
         
        } else if ((mouseY >= 400) && (mouseY <= 450)) {
            //quitter
           exit();

       }  
     }
   }
    

}

  void initJeu(int mode){
    if (mode==2) {
       state=2;
       vitesse=9; 
    } else if (mode ==3){
       state=3;
       vitesse=12;
    }
    
    frameRate(vitesse);
    
    //reinitialisations
     leScore = 0;
     dirX = -1;
     dirY = 0;
     taille = 3;
     
     compteurRelou = 150;

     obstacles = new obstacle[0];
     nbObstacles=0;
     
    modeSpeed=0;
    modeGhost=false;
    taille=3;
    serpent = new anneau[taille];
    for (int i = 0; i < taille; i++) {
      serpent[i] = new anneau(15+i,15);
    } 
    
    isPomme= false;
    isPommeIce=false;
  
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

void collectObstacle(){
 
   if ( (mousePressed)&&(compteurRelou==0)&& (!(mouseX>600&&mouseY>600)) ) {
     
     int futurObstacleX = min(30,max(int((mouseX+10)/k),1));
     int futurObstacleY = min(30,max(int((mouseY+10)/k),1));
     if((checkCollision(futurObstacleX,futurObstacleY)==0)&&((futurX!=futurObstacleX)||(futurY!=futurObstacleY))){

      
       
       nbObstacles = nbObstacles+1;
       obstacles= (obstacle[])expand(obstacles,nbObstacles);
       obstacles[nbObstacles-1] = new obstacle(futurObstacleX,futurObstacleY);

       
       compteurRelou = 150;
     
     }
       
     
    
      
  } else {
    // bah rien
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
    
    if (state==3){
      float aleat = random(0,10);
        if (aleat>9){
          isPommeIce=true;
        }else if(aleat>6.4 && modeGhost == false){
          isPommeGhost=true;
        }
    }
    
    // pomme démarrée
    pommeX=futurPommeX;
    pommeY=futurPommeY;
    isPomme = true;
    
  }

int checkCollision(int futurX,int futurY){
    // return 1 quand collision, 2 si pomme, 0 si rien
    //selfcollision
   for (int j = 0; j < taille; j++) {
      if (serpent[j].selfCollision(futurX,futurY)){
        return 1;
      }
   }
   //obstacle

     for (int l = 0; l < nbObstacles; l++) { //<>//
      if (obstacles[l].selfCollision(futurX,futurY)){
        return 1;
      }
   }
   
   //bords (devrait plus arriver
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
  // Constructor
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
  
    void displayGhost(int i) {

    fill(100+155/(i+1));
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

class obstacle {

  int x,y;
  
  obstacle(int tempX, int tempY) {
    x = tempX;
    y = tempY;
  } 
  
  
    boolean selfCollision(int futurX, int futurY){
    if ((futurX==x)&&(futurY==y)){
      return true;
    } else {
      return false;
    }
  }
  
   void display() {

    fill(0,0,250);
    noStroke();
    rect(x*k-10,y*k-10,20,20); 

   }
}

void effetPomme(int x, int y ){
  

  noStroke();
  if (isPommeIce){
    fill(10,10,250);
  } else if (isPommeGhost){
    fill(255,255,255);
  } else {
    fill(155,0,0);
  }
  
  ellipse(x*k,y*k,50,40);
  ellipse(x*k,y*k,40,50);

}