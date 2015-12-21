  int leScore = 0;
  int dirX = -1;
  int dirY = 0;
  int taille = 6;
  
  int futurX;
  int futurY;
  
  anneau[] serpent;
                     
  boolean isPomme = false;
  int pommeX;
  int pommeY;
  
  
  //Coefficient grid
  int k = 20;

void setup() {
  size(420, 420);
   frameRate(5);
  //initialisation du serpent 
  serpent = new anneau[taille];
  for (int i = 0; i < taille; i++) {
    serpent[i] = new anneau(15+i,15);
   } 
}


void draw() {
 
  background(204);
  
  affichageText();
  if (! isPomme) {
     nouvellePomme();
  } 
  
    //redessiner pomme
      rect(pommeX*k,pommeY*k,5,5);

  
  collectDirection();
  //prochain point
  futurX= serpent[0].x+dirX;
  futurY= serpent[0].y+dirY;
  
  if (checkCollision(futurX,futurY)){
      text("GAME OVER", 200,200);
      exit();
  } else {
    //Décalage de tableau
       for (int j = 0; j < taille-1; j++) {
          serpent[j+1] = serpent[j];
       }
   //ajout nouvelle tete
    serpent[0] = new anneau (futurX,futurY);
    
    
    
    //dessinerSerpent
   for (int j = 0; j < taille; j++) {
      serpent[j].display();
   }
    
  }
}


void affichageText(){
  
 fill(0);
  text(leScore, 5,15);
   //text("Da Snake ", 340, 380); 
     //text(KeyCode, 40, 380); 

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
    
    int futurPommeX = int(random(1,20));    
    int futurPommeY = int(random(1,20));
    
    //tester si la pomme ne tombe pas sur le serpent
    for (int j = 0; j < taille; j++) {
      if (serpent[j].selfCollision(futurPommeX,futurPommeY)){
        return ;
      }
    }
    
    // pomme démarrée
    pommeX=futurPommeX;
    pommeY=futurPommeY;
    isPomme = true;
    
  }

boolean checkCollision(int futurX,int futurY){
    // return true quand collision
   for (int j = 0; j < taille; j++) {
      if (serpent[j].selfCollision(futurX,futurY)){
        return true;
      }
   }
   // si pomme, étendre taille de 1
   if ((futurX==pommeX) && (pommeY==futurY)){
     taille = taille+1;
     leScore = leScore+taille;
     isPomme = false;
     serpent = append(serpent,new anneau(0,0) );
   }
    
    return false;
    
 }

  
  class anneau {

  int x,y;   // x et y de 1 à 20
  // Cell Constructor
  anneau(int tempX, int tempY) {
    x = tempX;
    y = tempY;
  } 
  
  void display() {
    
    fill(127+127*sin(x+y));
    ellipse(x*k,y*k,10,10); 
  }
  
  boolean selfCollision(int futurX, int futurY){
    if ((futurX==x)&&(futurY==y)){
      return true;
    } else {
      return false;
    }
  }
}