##4. Experiments

###Experiment with the dinner, will the philosophers always be able to eat?

It seems so, although with varying time delay between when eating and sleeping. 

Also, everyone just eats in the same order of being created which seems rather ineffective considering the free chopsticks lying around.

1 Arendt received two chopsticks
1 Arendt done
2 Hypatia received two chopsticks
2 Hypatia done
3 Simone received two chopsticks
3 Simone done
4 Elizabeth received two chopsticks
4 Elizabeth done
5 Ayn received two chopsticks
5 Ayn done


###What happens if you decrease the time it dreams?

The same as above but faster.

###What happens if youn introduce an artificial delay between the receiving of the first chopstick and requesting the second?

Everyone picks up their left chopstick and waits for the one on their right to get free, which it never will. We get a deadlock.


##4.1 break the deadlock

###So you have broken the dead-lock, or so you think, but what is actually happening?

###What happens when a philosopher gives up?

With the newly added timeout in the chopstick module that we still get stuck in a deadlock of philosophers just timing out in their requests ..

5 Ayn dropped right
3 Simone dropped right
5 Ayn dropped right
3 Simone dropped right
5 Ayn dropped right
3 Simone dropped right
5 Ayn dropped right
3 Simone dropped right
5 Ayn dropped right
3 Simone dropped right
5 Ayn dropped right

using now() to generate unique seed values for each process, now() is deprecated but school uses old erlang version? works for our implementation.
Now it works!

##4.2 asynchronous requests

###If a philosopher gives up, how do we keep track of which chopsticks that was actually obtained?

We can't, since we don't keep track of requests.

###Is this a tricky problem or a non-problem?




