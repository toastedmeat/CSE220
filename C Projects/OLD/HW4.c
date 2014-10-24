/* 
 * File:   HW2.c
 * Author: Eric Loo
 *
 * Created on September 23, 2013, 3:14 PM
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * 
 */
int Player1Score = 0;
int Player2Score = 0;
int turnScore = 0;
int GOAL = 0, Seed = 0;
char player1[25], player2[25];
int rolledNumber1 = 0, rolledNumber2 = 0;
int players = 1;

void printScoreTable(void);
void drawDie(int DiceValue);
int rollDie(void);
int checkDice(int player, int die1, int die2);
int winner(void);
char options[0];

int main(void) {
    printf("Enter seed number: ");
    scanf("%d", &Seed);
    srand(Seed);

    printf("Enter Player 1's name: ");
    scanf("%s", player1);

    printf("Enter Player 2's name: ");
    scanf("%s", player2);

    printf("%s\n", "Hello, Enter the value to Win (20-1000): ");
    scanf("%d", &GOAL);
    printf("%s\t%s\n", player1, "Enter \"R\" to roll the dice:");
    while (winner() == 0) {
        if (players == 1) {
            scanf("%c", options);
            if (options[0] == 'r' || options[0] == 'R') {
                rollDie();
                drawDie(rolledNumber1);
                drawDie(rolledNumber2);
                turnScore = 0;
                checkDice(1, rolledNumber1, rolledNumber2);
                if (checkDice(Player1Score, rolledNumber1, rolledNumber2) == 3) {
                    printf("You rolled doubles, You must roll again press R");
                    scanf("%c", options);
                } else if (checkDice(Player1Score, rolledNumber1, rolledNumber2) == 0) {
                    printf("You rolled 2-6, You can roll again (R) or hold (h)");
                    scanf("%c", options);
                }

            } else if (options[0] == 'h' || options[0] == 'H') {
                Player1Score += turnScore;
                printScoreTable();
                players++;
            }
        } else if (players == 2) {
            printf("%s\t%s\n", player2, "Enter \"R\" to roll the dice:");
            scanf("%c", options);
            if (options[0] == 'r' || options[0] == 'R') {
                rollDie();
                drawDie(rolledNumber1);
                drawDie(rolledNumber2);
                turnScore = 0;
                checkDice(2, rolledNumber1, rolledNumber2);
                if (checkDice(Player1Score, rolledNumber1, rolledNumber2) == 3) {
                    printf("You rolled doubles, You must roll again press R");
                    scanf("%c", options);
                } else if (checkDice(Player1Score, rolledNumber1, rolledNumber2) == 0) {
                    printf("You rolled 2-6, You can roll again (R) or hold (h)");
                    scanf("%c", options);
                }

            } else if (options[0] == 'h' || options[0] == 'H') {
                Player2Score += turnScore;
                printScoreTable();
                players--;
            }


        }
    }
    if(winner() == 1){
        printf("CONGRATULATIONS %s YOU WON!",player1); 
    } else if(winner() == 2){
        printf("CONGRATULATIONS %s YOU WON!",player2); 
    }
    printf("Enter “P” to Play again or “Q” to Quit: ");


}

void printScoreTable(void) {
    printf("Player:\t%s\t%s\n", player1, player2);
    printf("----------------------\n");
    printf("       \t%d/%d\t%d/%d\n", Player1Score, GOAL, Player2Score, GOAL);
}

void drawDie(int DiceValue) {
    switch (DiceValue) {
        case 1:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|   |", "| o |", "|   |", "-----");
            break;
        case 2:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|o  |", "|   |", "|  o|", "-----");
            break;
        case 3:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|o  |", "| o |", "|  o|", "-----");
            break;
        case 4:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|o o|", "|   |", "|o o|", "-----");
            break;
        case 5:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|o o|", "| o |", "|o o|", "-----");
            break;
        case 6:
            printf("%s\n%s\n%s\n%s\n%s\n", "-----", "|o o|", "|o o|", "|o o|", "-----");
            break;
    }
}

int rollDie(void) {
    rolledNumber1 = 1 + (int) (6.0 * rand() / (RAND_MAX + 1.0));
    rolledNumber2 = 1 + (int) (6.0 * rand() / (RAND_MAX + 1.0));
}

int checkDice(int player, int die1, int die2) {
    if ((die1 == 1 || die2 == 1) && (die1 != die2)) {
        printf("Your score nothing and your turns over\n");
        return 1;
    } else if (die1 == 1 && die2 == 1) {
        if (player = 1) {
            Player1Score = 0;
            printf("Your score went back to 0 and your turns over\n");
            return 2;
        } else {
            Player2Score = 0;
            printf("Your score went back to 0 and your turns over\n");
            return 2;
        }
    } else if (die1 == die2) {
        turnScore += (2 * (die1 + die2));
        printf("Congratulations, you got doubles!\n");
        printf("Points earned: %d\n", (2 * (die1 + die2)));
        printf("Total points: %d\n", turnScore);
        return 3;
    } else if (die1 >= 2 && die1 <= 6 && die2 >= 2 && die2 <= 6) {
        turnScore += die1 + die2;
        printf("Points earned: %d\n", (die1 + die2));
        printf("Turn points: %d\n", turnScore);
        return 0;
    }
}

int winner(void) {
    if (Player1Score >= GOAL) {
        return 1;
    } else if (Player2Score >= GOAL) {
        return 2;
    } else {
        return 0;
    }
}
