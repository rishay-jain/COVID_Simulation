# COVID_Simulation

This project is a Nifty Assignment for APCSA. 

The program accomplishes the task of modelling the SARS-CoV-2 pandemic. It uses a grid of cells to represent the population, with the color of the cell representing an individual's status of infection (based on whether they are infected or not as well as whether they cooperate with the preventive measures). The display continuously updates with the latest infections and deaths.

I exported data from the simulation with different levels of public cooperation and graphed it. 

Figure 1 shows the infections and deaths over time with a relatively low percentage of the population not cooperating (11%). We can see a large peak immediately after the start of the simulation, as the virus spread rapidly throughout the population. After most of the population was infected, the ones who recovered (recovery happens after 3 cycles) had immunity for 3 cycles after that, meaning that a large amount of the population could not be infected. This effect, herd immunity, prevented the infection level from increasing. 

Figure 2 compares the infections over time of two scenarios with differing rates of public cooperation (11% not cooperating and 71% not cooperating). We can see a marked difference in the number of infections. The 71% non-cooperation simulation has a much higher peak at the beginning, not surprisingly, but it tapers off at a greater average infection load. The 'second wave' of cases, caused by the rebound once immunity weakens, comes much earlier in the 11% simulation compared to the 71%. However, while the second wave comes quickly and disappears quickly in the 11% simulation, the 71% simulation's second wave stays for a longer period of time and maintains a greater average infection load. 

The graphed data shows that even in a basic simulation such as this one, the presence of the second wave and the idea of 'flattening the curve' is clearly displayed. 
