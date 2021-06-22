;#lang racket
;(- 4 5 6)
;(- 6 5 4 )
;This is an postfix interpreter.
;It can negate a number e.g.(5 -)-> -5
;It can reverse a number by multiplication e.g. 5 / -> 1/5
;It can calculate multiple numbers on one arithmetic operator like 4 5 6 + -> 15 or 12 4 3 / ->1 it doesnt matter how many numbers on one operator.
;It does the division and subtraction operation in ordinary racket's order.
;In racket (- 5  6) -> -1 and (/ 10 2) -> 5. In my interpreter is also like that.
;It can detect zero division error and it displays a simple error message and it does not return anything as a result of that line
;It can't do nested operations because I couldn't handle parenthesis but
;It can do serial operation without parenthesis like 4 5 * 3 4 + 2 1 * -> ((20 + 7) * 2) -> 54 on the one line.
;It reads until finding the first arithmetic operator then it calculates all numbers according to that arithmetic operator then push the result into a stack and
;It does this for every number and arithmetic operator pairs (like 4 5 6 *)  that's why it can calculate serial operations on one line.
;It reads every line and return the result of the line respectively

;I would like to so many thanks to Matthew Butterick who is the writer of beatiful racket. -> His book link ( https://beautifulracket.com/ )

;I would like to so many thanks to participants on Reddit who answer my question about this assignment (especially Trevor from USA).
;Subreddit link -> (https://www.reddit.com/r/Racket/) My questions are still on there (u/hasanaliozkan).


; I leave examples below that are mentioned above.

#lang reader "my-interpreter.rkt"
5 -
5 /
1 2 3 4 5 6 7 8 9 +
1 2 3 4 5 * 1 2 3 4 5 *
5 6 -
10 2 /
12 4 3 0 /
0 /
4 5 * 3 4 + 2 1 *












