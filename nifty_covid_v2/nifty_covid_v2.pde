int size = 10; //this is the size of each individual cell in pixels
int adj_height = 825; //height of usable field (adjusted for infographics panel)
int border = 2; //size of border between cells
int bgcolor = 100; // background color
int width = 1440;

int arrayx = width / (size + border); // variable storing consistent array dimensions based on parameters
int arrayy = adj_height / (size + border);

Particle parts[][] = new Particle[arrayx][arrayy]; //stores all cells in population

class Probability{ // allows for easier calculation of booleans based on probability
  boolean calculate(double coef){
    if (random(100) <= (float)(coef * 100.0)){
      return true;
    }
    else{
      return false;
    }
  }
    
}

Probability probability = new Probability();

class Particle{ // particle class represents each individual person in population
  int xpos;
  int ypos;
  boolean alive = true;
  boolean infected = false;
  boolean just_infected = false;
  boolean cooperative;
  boolean immune = false;
  
  int cycles_immune = 0; // used for measuring how long person has been infected/immune
  int cycles_infected = 0;
  
  double prob_not_coop = 0.31; //probability that person is not cooperative (masking, distancing, etc)
  double prob_infected = 0.01; //probability that this person is infected (initial cases 'kickstarting' the pandemic)
  double prob_recovered = 0.8; //probability that person recovers from infection
  
  double prob_infection_after_contact = 0.5; // if cooperative, probability that they catch virus after close contact
  double non_coop_infection_after_contact = 0.95; // if not cooperative, probability that they catch virus after close contact
   
  Particle (int x, int y){
    xpos = x;
    ypos = y; 

    //rect(toPixel(x),toPixel(y),size,size);
    
    if(probability.calculate(prob_not_coop)){ // decide individual factors (cooperation, initial infection, etc.)
      cooperative = false;
    }
    else{
      cooperative = true;
    }
    if(probability.calculate(prob_infected)){
      infected = true;
    }
    else{
      infected = false;
    }
  }
  void drawParticle(){ // draw the person on the population map
    if(!infected){
        if(cooperative){
          if (probability.calculate(prob_infection_after_contact)){
            infected = just_infected;
          }
        }
        if(!cooperative){
          if (probability.calculate(non_coop_infection_after_contact)){
            infected = just_infected;
          }
        }
      }
      if(infected || just_infected){
        cycles_infected += 1;
      }
      
      if(cycles_infected >= 3){ // if they've been infected for 3 or more cycles, decide whether they recover or not
        if(probability.calculate(prob_recovered)){ // recovered
          infected = false;
          just_infected = false;
          immune = true; // immunity if they recover
          cycles_infected = 0;
        }
        else{ // dead
          infected = false;
          just_infected = false;
          alive = false;
          cycles_infected = 0;
        }
      }
      
      if(immune){ // immunity lasts for 3 cycles only, then they are vulnerable again
        cycles_immune += 1;
        infected = false;
        just_infected = false;
      }
      if(cycles_immune >= 3){
        immune = false;
      }
      
    if(alive == true){
      

      if(cooperative && !infected){ // choose color based on status
        fill(50,150,50); //green if cooperative and not infected
      }
      if(!cooperative && !infected){
        fill(50,50,150); //blue if not cooperative and not infected
      }
      if(cooperative && infected){
        fill(250,250,50); //yellow if cooperative and infected
      }
      if(!cooperative && infected){
        fill(200,50,50); //red if not cooperative and infected
      }
    }
    else{
      fill(0); //black if deceased
    }
    rect(toPixel(xpos),toPixel(ypos),size,size);
  }
 
  
  int toPixel (int value){ // converting from array index to pixel units
    int newvalue = value * (size +2);
    return newvalue;
  }
    
  void update_cycles(){ 
    if(infected){
      cycles_infected += 1;
    }
  }
  
}

class Grid{ //the class for the grid environment

  void drawGrid(){ //function to draw the grid every iteration
      background(bgcolor);
      for (int x =0; x<= 120; x+= 1){
        for(int y =0; y<= arrayy; y+= 1){
          fill(0);
          rect(toPixel(x),toPixel(y),size,size);
   
        }  
      }
    
  }

  
  int toPixel (int value){
    int newvalue = value * (size +2);
    return newvalue;
  }
}

class Infographics{ // infographics panel at the bottom of the screen
  void display(int cycle, int num_total, int num_dead,int num_infected){
    fill(150);
    rect(0,adj_height,width,height);
    fill(255);
    textSize(32);
    
    text("Cycle: " + cycle + "      Total: " + num_total + "      Dead: " + num_dead + "      Infected: " + num_infected,100,875);
  }
  void showKey(){ // display the legend for colors at the side of the screen
    
    int xloc = 1100;
    int yloc = 675;
    
    noStroke();
    fill(150);
    rect(xloc - 10,yloc,325,125);
    fill(255);
    textSize(24);
    
    fill(50,150,50); //green if cooperative and not infected
    rect(xloc, yloc + 25, 10,10);
    fill(50,50,150); //blue if not cooperative and not infected
    rect(xloc, yloc + 50, 10,10);
    fill(250,250,50); //yellow if cooperative and infected
    rect(xloc, yloc + 75, 10,10);
    fill(200,50,50); //red if not cooperative and infected
    rect(xloc, yloc + 100, 10,10);
    fill(255);
    stroke(1);
    
    text("Cooperative, Not Infected",xloc + 15,yloc + 37.5); //g
    text("Not Cooperative, Not Infected",xloc + 15,yloc + 62.5); // b
    text("Cooperative, Infected",xloc + 15,yloc + 87.5); // y
    text("Not Cooperative, Infected",xloc + 15,yloc + 112.5); //r
    
  }
  
  void button_draw(){ //draw the restart button
    int buttonx = 1000;
    int buttony = 860;
    fill(200,25,25);
    ellipse(buttonx, buttony, 50,50);
    textSize(12);
    fill(255);
    text ("Restart", buttonx - 17, buttony + 3);
  }
  boolean restart_pressed(){ //if restart pressed
    if(mousePressed && dist(mouseX,mouseY, 1000,860) <= 50){
      return true;
    }
    else{
      return false;
    }
  }
  
  
}

class Population{ // the population class manages the array of people
  int num_dead;
  int num_infected;
  int num_total;
  int cycle;
  

  
  
  void create(){
    num_dead = 0;
    num_infected = 0;
    num_total = 0;
    cycle = 0; 
    
    for(int i = 0; i<= (arrayx-1); i++){
      for(int x = 0; x<= (arrayy-1); x++){
        parts[i][x] = new Particle(i,x); //create a cell at each index
        num_total ++;
        //println(parts[i][x]);
       }
      }
      
  }
  int update_num_dead(){
    num_dead = 0;
    for(int i = 0; i<= (arrayx-1); i++){
      for(int x = 0; x<= (arrayy-1); x++){
        if(!(parts[i][x].alive)){
          num_dead++;
        }
       }
      }
    return num_dead;
  }
  
  int update_num_infected(){
    num_infected = 0;
    for(int i = 0; i<= (arrayx-1); i++){
      for(int x = 0; x<= (arrayy-1); x++){
        if(parts[i][x].infected){
          num_infected++;
        }
       }
      }
    return num_infected;
  }
  
  void determine(){
    cycle += 1;
    int left;
    int right;
    
    int above;
    int below;

    
   for(int i = 0; i<= (arrayx-1); i++){
      for(int x = 0; x<= (arrayy-1); x++){
        
        left = i - 1;
        right = i + 1;
        above = x - 1;
        below = x + 1;
        
        if(i == 0){
          left = i;
        }
        if(i == (arrayx - 1)){
          right = i;
        }
        if(x == 0){
          above = x;
        }
        if(x == (arrayy - 1)){
          below = x;
        }
        if(parts[i][x].alive){
         
            //determine with 1 block check
            if(parts[left][above].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[i][above].infected){ // check each cell around the cell in question to determine infection status
              parts[i][x].just_infected = true;
          }
          
          if(parts[right][above].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[right][x].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[right][below].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[i][below].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[left][below].infected){
              parts[i][x].just_infected = true;
          }
          
          if(parts[left][x].infected){
              parts[i][x].just_infected = true;
          }
          
        
        }
      
    }
  }
  
}
  void display(){
    for(int i = 0; i<= (arrayx-1); i++){
      for(int x = 0; x<= (arrayy-1); x++){       
        //println(parts[i][x]);
        parts[i][x].drawParticle(); // draw person
      }
    }
  }
}

class Simulation{ // simulation allows for the population to be reset during run
  
  void restart(){
    population.create();
    population.display();
    
  }
  
  
}


Table table; // for data collection
TableRow[] row = new TableRow[100];

Population population = new Population();
Infographics info = new Infographics();
Grid grid = new Grid();
Simulation simulation = new Simulation();

void setup(){
  fullScreen();
  background(bgcolor);
  
  table = new Table();
  table.addColumn("cycle");
  table.addColumn("num_total");
  table.addColumn("num_infected");
  table.addColumn("num_dead");
  
  population.create();
  population.display();
  info.display(0,0,0,0);
}

void draw(){
  delay(200);
  grid.drawGrid(); // draw grid
  population.determine(); // determine infection status
  population.display(); // display population with new status
  info.display(population.cycle,population.num_total,population.update_num_dead(),population.update_num_infected()); //display info in panel
  info.showKey(); // show the color legend
  info.button_draw(); //draw the button 
  if(info.restart_pressed()){ // if pressed restart
    simulation.restart();
  }
  
  if(population.cycle >= 99){ // save data after 100 cycles
    saveTable(table,"data3.csv");
  }
  else{  
    row[population.cycle] = table.addRow();
    row[population.cycle].setInt("cycle",population.cycle);
    row[population.cycle].setInt("num_total",population.num_total);
    row[population.cycle].setInt("num_infected",population.num_infected);
    row[population.cycle].setInt("num_dead",population.num_dead);
  }
  
}
