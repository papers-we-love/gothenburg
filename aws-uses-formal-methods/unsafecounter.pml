/*
Source: http://spinroot.com/spin/Doc/p40-ben-ari.pdf
*/

byte n = 0, finish = 0;
active [2] proctype P() {
    byte reg, counter = 0;
    do 
    :: counter == 10 -> break
    :: else ->  reg = n;
                reg++;
                n = reg;
                counter++
    od;
    finish++
}

/*propositions*/

#define nonneg (n>=0)
#define min (n>=10)
#define max (n<=20)
#define range (min && max)
#define done (finish==2)

/*LTL formula*/
ltl p { always (done implies range) }

