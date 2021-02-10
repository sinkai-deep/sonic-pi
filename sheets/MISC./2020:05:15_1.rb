##| Welcome to Sonic Pi v3.0
use_bpm 135
live_loop :bass do
  
  
  use_synth :tb303
  
  sample :ambi_drone, release: 2, amp: 0.75
  4.times do
    
    play 48, release: 0.1, cutoff: rrand(30,110)
    sleep 0.25
    play 36, cutoff: rrand(50,80)
    sleep 0.5
    play 48, release: 0.1, cutoff: rrand(30,80)
    sleep 1
    play 36, release: 0.1, cutoff: rrand(30,80)
    sleep 0.25
    play 48, release: 0.1, cutoff: rrand(30,80)
    sleep 0.25
    play 36, release: 0.1, cutoff: rrand(30,130)
    sleep 0.75
    play 48, release: 0.2, cutoff: rrand(30,80)
    sleep 1.55
    
    play 36, release: 0.1, cutoff: rrand(30,120)
    sleep 0.25
    play 48, release: 0.1, cutoff: rrand(30,80)
    sleep 0.25
    play 36, release: 0.1, cutoff: rrand(30,80)
    sleep 0.5
    play 48, release: 0.1, cutoff: rrand(30,80)
    sleep 0.5
    play 48, release: 0.1, cutoff: rrand(30,110)
    sleep 0.25
    play 36, release: 0.1, cutoff: rrand(30,80)
    sleep 0.5
    play 36, release: 0.1, cutoff: rrand(30,100)
    sleep 0.25
    play 48, release: 0.1, cutoff: rrand(30,80)
    sleep 1
  end
  
  4.times do
    use_synth :beep
    play 48
    sleep 0.25
    play 36
    sleep 0.5
    play 48
    sleep 1
    play 36
    sleep 0.25
    play 48
    sleep 0.25
    play 36
    sleep 0.75
    play 48
    sleep 1.55
    
    play 36
    sleep 0.25
    play 48
    sleep 0.25
    play 36
    sleep 0.5
    play 48
    sleep 0.5
    play 48
    sleep 0.25
    play 36
    sleep 0.5
    play 36
    sleep 0.25
    play 48
    sleep 1
  end
end
  




