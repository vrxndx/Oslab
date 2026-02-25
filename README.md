Experiment 11
Simulation of Banker’s Algorithm

Aim
To obtain a deadlock-free process mix and simulate the Banker’s Algorithm to determine a safe execution sequence.
Algorithm
START
Input number of processes n
Input number of resources m
Input Allocation matrix
Input Maximum matrix
Input Available vector
Compute Need = Max - Allocation
Initialize:
Work = Available
Finish[i] = false for all i
WHILE (there exists a process i such that
       Finish[i] == false AND Need[i] <= Work)
Work = Work + Allocation[i]
    Finish[i] = true
    Add Pi to safe sequence
END WHILE
IF all Finish[i] == true
    System is in SAFE STATE
    Print safe sequence
ELSE
    System is in UNSAFE STATE
STOP


Program
#include <stdio.h>
#define MAX 10

int main() {
    int n, m, i, j, k;
    int allocation[MAX][MAX], max[MAX][MAX];
    int need[MAX][MAX];
    int available[MAX];
    int finish[MAX] = {0};
    int safeSequence[MAX];
    int work[MAX], count = 0;

    printf("Enter number of processes: ");
    scanf("%d", &n);

    printf("Enter number of resource types: ");
    scanf("%d", &m);

    printf("Enter Allocation Matrix:\n");
    for(i = 0; i < n; i++)
        for(j = 0; j < m; j++)
            scanf("%d", &allocation[i][j]);

    printf("Enter Maximum Matrix:\n");
    for(i = 0; i < n; i++)
        for(j = 0; j < m; j++)
            scanf("%d", &max[i][j]);

    printf("Enter Available Resources:\n");
    for(i = 0; i < m; i++)
        scanf("%d", &available[i]);

    // Calculate Need Matrix
    for(i = 0; i < n; i++)
        for(j = 0; j < m; j++)
            need[i][j] = max[i][j] - allocation[i][j];

    // Initialize Work = Available
    for(i = 0; i < m; i++)
        work[i] = available[i];

    while(count < n) {
        int found = 0;

        for(i = 0; i < n; i++) {
            if(finish[i] == 0) {
                for(j = 0; j < m; j++) {
                    if(need[i][j] > work[j])
                        break;
                }

                if(j == m) {
                    for(k = 0; k < m; k++)
                        work[k] += allocation[i][k];

                    safeSequence[count++] = i;
                    finish[i] = 1;
                    found = 1;
                }
            }
        }

        if(found == 0) {
            printf("System is NOT in Safe State\n");
            return 0;
        }
    }

    printf("System is in SAFE STATE\nSafe Sequence: ");
    for(i = 0; i < n; i++)
        printf("P%d ", safeSequence[i]);

    printf("\n");

    return 0;
}

SAMPLE OUTPUT
System is in SAFE STATE
Safe Sequence: P1 P3 P4 P0 P2

Manual Safe Sequence Determination
Initial:
Work = [3, 3, 2]
Check processes:
•	P1 → Need = [1,2,2] ≤ [3,3,2] ✔
New Work = [5,3,2]
•	P3 → Need = [0,1,1] ≤ [5,3,2] ✔
New Work = [7,4,3]
•	P4 → Need = [4,3,1] ≤ [7,4,3] ✔
New Work = [7,4,5]
•	P0 → Need = [7,4,3] ≤ [7,4,5] ✔
New Work = [7,5,5]
•	P2 → Need = [6,0,0] ≤ [7,5,5] ✔
New Work = [10,5,7]
Safe Sequence
<P1, P3, P4, P0, P2>
System is in SAFE STATE.






















✅ Line-by-Line Explanation of Banker’s Algorithm Program
 
#include <stdio.h>
➡ Includes standard input-output functions like printf() and scanf().
 
#define MAX 10
➡ Defines maximum number of processes and resources as 10.
This avoids dynamic memory allocation and keeps the program simple.
 
int main() {
➡ Program execution starts from the main() function.
 
int n, m, i, j, k;
➡ Variable declarations:
•	n → number of processes
•	m → number of resource types
•	i, j, k → loop variables
 
int allocation[MAX][MAX], max[MAX][MAX];
➡ Two 2D arrays:
•	allocation → currently allocated resources
•	max → maximum resources each process may request
 
int need[MAX][MAX];
➡ Stores remaining resource needs of each process.
Formula:
Need = Max - Allocation
 
int available[MAX];
➡ Stores available instances of each resource.
 
int finish[MAX] = {0};
➡ finish[i] = 0 means process i is not completed.
➡ finish[i] = 1 means process is completed.
Initially all are unfinished.
 
int safeSequence[MAX];
➡ Stores the safe sequence of execution.
 
int work[MAX], count = 0;
➡ work → temporary copy of available resources.
➡ count → number of processes completed so far.
 
🔹 Input Section
 
printf("Enter number of processes: ");
scanf("%d", &n);
➡ Reads number of processes.
 
printf("Enter number of resource types: ");
scanf("%d", &m);
➡ Reads number of resource types.
 
printf("Enter Allocation Matrix:\n");
for(i = 0; i < n; i++)
    for(j = 0; j < m; j++)
        scanf("%d", &allocation[i][j]);
➡ Reads allocation matrix values.
 
printf("Enter Maximum Matrix:\n");
for(i = 0; i < n; i++)
    for(j = 0; j < m; j++)
        scanf("%d", &max[i][j]);
➡ Reads maximum requirement matrix.
 
printf("Enter Available Resources:\n");
for(i = 0; i < m; i++)
    scanf("%d", &available[i]);
➡ Reads available resource vector.
 
🔹 Need Matrix Calculation
 
for(i = 0; i < n; i++)
    for(j = 0; j < m; j++)
        need[i][j] = max[i][j] - allocation[i][j];
➡ Calculates remaining resource requirement for each process.
Formula:
Need[i][j] = Max[i][j] - Allocation[i][j]
 
🔹 Initialize Work Vector
 
for(i = 0; i < m; i++)
    work[i] = available[i];
➡ Copy available resources into work.
We do this because we should not modify original available vector.
 
🔹 Main Banker’s Algorithm Logic
 
while(count < n) {
➡ Repeat until all processes are finished.
 
int found = 0;
➡ Flag variable to check whether any process was able to execute in this iteration.
 
for(i = 0; i < n; i++) {
➡ Check each process one by one.
 
if(finish[i] == 0) {
➡ Check if process i is not already finished.
 
for(j = 0; j < m; j++) {
    if(need[i][j] > work[j])
        break;
}
➡ Check if process i’s need is less than or equal to available work.
If any resource needed is greater than available → stop checking that process.
 
if(j == m) {
➡ If loop completed fully, it means:
Need ≤ Work
So process can safely execute.
 
for(k = 0; k < m; k++)
    work[k] += allocation[i][k];
➡ After execution, process releases allocated resources.
➡ Add allocated resources back to work.
 
safeSequence[count++] = i;
➡ Store process number in safe sequence.
➡ Increase count.
 
finish[i] = 1;
➡ Mark process as completed.
 
found = 1;
➡ Indicate that a process was successfully executed in this iteration.
 
}
}
➡ Close if and for loops.
 
if(found == 0) {
    printf("System is NOT in Safe State\n");
    return 0;
}
➡ If no process could execute in an entire cycle:
•	System is unsafe.
•	Deadlock possible.
•	Exit program.
 
🔹 Safe State Printing
 
printf("System is in SAFE STATE\nSafe Sequence: ");
➡ Print safe state message.
 
for(i = 0; i < n; i++)
    printf("P%d ", safeSequence[i]);
➡ Print safe execution order.
 
printf("\n");
return 0;
}
➡ End of program.
EXPERIMENT 12
OBTAIN A PROCESS MIX AND DETERMINE WHETHER THE SYSTEM IS DEADLOCKED

Aim
To obtain a process mix (Allocation and Request matrices) and determine whether the system is in a deadlocked state using the Deadlock Detection Algorithm.
Algorithm
START
Input Allocation matrix
Input Request matrix
Input Available vector

Work = Available

For each process i
    If Allocation[i] == 0
        Finish[i] = true
    Else
        Finish[i] = false

While there exists process i such that
    Finish[i] == false AND
    Request[i] <= Work

    Work = Work + Allocation[i]
    Finish[i] = true

If any Finish[i] == false
    System is deadlocked
Else
    No deadlock
STOP

Program
#include <stdio.h>
#define MAX 10
int main() {
    int n, m, i, j, k;
    int allocation[MAX][MAX], request[MAX][MAX];
    int available[MAX], work[MAX];
    int finish[MAX];

    printf("Enter number of processes: ");
    scanf("%d", &n);

    printf("Enter number of resource types: ");
    scanf("%d", &m);

    printf("Enter Allocation Matrix:\n");
    for(i = 0; i < n; i++)
        for(j = 0; j < m; j++)
            scanf("%d", &allocation[i][j]);

    printf("Enter Request Matrix:\n");
    for(i = 0; i < n; i++)
        for(j = 0; j < m; j++)
            scanf("%d", &request[i][j]);

    printf("Enter Available Vector:\n");
    for(i = 0; i < m; i++)
        scanf("%d", &available[i]);

    // Initialize Work = Available
    for(i = 0; i < m; i++)
        work[i] = available[i];

    // Initialize Finish
    for(i = 0; i < n; i++) {
        int flag = 0;
        for(j = 0; j < m; j++) {
            if(allocation[i][j] != 0) {
                flag = 1;
                break;
            }
        }
        if(flag == 0)
            finish[i] = 1;
        else
            finish[i] = 0;
    }

    // Deadlock Detection
    for(i = 0; i < n; i++) {
        for(j = 0; j < n; j++) {
            if(finish[j] == 0) {
                for(k = 0; k < m; k++) {
                    if(request[j][k] > work[k])
                        break;
                }

                if(k == m) {
                    for(k = 0; k < m; k++)
                        work[k] += allocation[j][k];

                    finish[j] = 1;
                }
            }
        }
    }

    // Check for deadlock
    int deadlock = 0;
    for(i = 0; i < n; i++) {
        if(finish[i] == 0) {
            deadlock = 1;
            printf("Process P%d is deadlocked\n", i);
        }
    }

    if(deadlock == 0)
        printf("System is NOT Deadlocked\n");

    return 0;
}
 Result
The process mix was tested using the Deadlock Detection Algorithm and the system was found to be not deadlocked.
Sample Output
System is NOT Deadlocked


Deadlock Detection Algorithm Program
 
#include <stdio.h>
➡ Includes standard input-output functions like printf() and scanf().
 
#define MAX 10
➡ Defines maximum number of processes and resources as 10.
 
int main() {
➡ Execution of the program starts from main().
 
🔹 Variable Declarations
 
int n, m, i, j, k;
➡ n → Number of processes
➡ m → Number of resource types
➡ i, j, k → Loop control variables
 
int allocation[MAX][MAX], request[MAX][MAX];
➡ allocation → Stores currently allocated resources to processes.
➡ request → Stores additional resources each process is requesting.
 
int available[MAX], work[MAX];
➡ available → Stores available instances of each resource.
➡ work → Temporary copy of available resources used in simulation.
 
int finish[MAX];
➡ finish[i]:
•	0 → Process not completed
•	1 → Process completed
 
🔹 Input Section
 
printf("Enter number of processes: ");
scanf("%d", &n);
➡ Reads number of processes.
 
printf("Enter number of resource types: ");
scanf("%d", &m);
➡ Reads number of resource types.
 
printf("Enter Allocation Matrix:\n");
for(i = 0; i < n; i++)
    for(j = 0; j < m; j++)
        scanf("%d", &allocation[i][j]);
➡ Reads Allocation matrix values from user.
 
printf("Enter Request Matrix:\n");
for(i = 0; i < n; i++)
    for(j = 0; j < m; j++)
        scanf("%d", &request[i][j]);
➡ Reads Request matrix.
 
printf("Enter Available Vector:\n");
for(i = 0; i < m; i++)
    scanf("%d", &available[i]);
➡ Reads Available resources.
 
🔹 Initialize Work Vector
 
for(i = 0; i < m; i++)
    work[i] = available[i];
➡ Copy Available vector to Work vector.
➡ We use Work for simulation so that original Available is not modified.
 
🔹 Initialize Finish Array
 
for(i = 0; i < n; i++) {
➡ Loop through each process.
 
int flag = 0;
➡ Flag variable to check if process has any allocated resource.
 
for(j = 0; j < m; j++) {
    if(allocation[i][j] != 0) {
        flag = 1;
        break;
    }
}
➡ If allocation is not zero → process holds some resources.
 
if(flag == 0)
    finish[i] = 1;
else
    finish[i] = 0;
➡ If process has no allocated resources → mark it as finished (cannot be in deadlock).
➡ Otherwise mark as unfinished.
 
🔹 Deadlock Detection Logic
 
for(i = 0; i < n; i++) {
➡ Repeat checking multiple times (maximum n times).
 
for(j = 0; j < n; j++) {
➡ Check each process one by one.
 
if(finish[j] == 0) {
➡ Consider only unfinished processes.
 
for(k = 0; k < m; k++) {
    if(request[j][k] > work[k])
        break;
}
➡ Check if process request ≤ available work.
If any requested resource is more than available → stop checking that process.
 
if(k == m) {
➡ If loop completed fully, it means:
Request ≤ Work
So process can complete.
 
for(k = 0; k < m; k++)
    work[k] += allocation[j][k];
➡ After process completes, release its allocated resources back to work.
 
finish[j] = 1;
➡ Mark process as completed.
 
🔹 Deadlock Checking
 
int deadlock = 0;
➡ Variable to check whether deadlock exists.
 
for(i = 0; i < n; i++) {
    if(finish[i] == 0) {
        deadlock = 1;
        printf("Process P%d is deadlocked\n", i);
    }
}
➡ If any process is still unfinished → it is deadlocked.
 
if(deadlock == 0)
    printf("System is NOT Deadlocked\n");
➡ If all processes finished → system is not deadlocked.
 
return 0;
}
➡ End of program.
 
✅ Overall Working Summary 
1.	Read Allocation, Request, and Available.
2.	Copy Available to Work.
3.	Mark processes with zero allocation as finished.
4.	Find a process whose:
o	Finish = 0
o	Request ≤ Work
5.	If found:
o	Release its allocation to Work
o	Mark as finished
6.	Repeat until no more processes can execute.
7.	If any process remains unfinished → Deadlock exists.




# Oslab
