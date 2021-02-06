bpm = 120
vol = 1

live_loop :bd do
  4.times do
    use_bpm bpm
    3.times do
      sample :bd_tek, release: 0.5, amp: 1, rate: 0.5
      sleep 1
      sample :bd_tek, release: 0.5, amp: 1, rate: 0.5
      sleep 1
      sample :bd_tek, release: 0.5, amp: 1, rate: 0.5
      sleep 1
      sample :bd_tek, release: 0.5, amp: 1.3, rate: 0.5
      sleep 1
    end
    sample :bd_tek, release: 0.8, amp: 1,  rate: 0.5
    sleep 1
    sample :bd_tek, release: 0.5, amp: 1,  rate: 0.5
    sleep 1
    sample :bd_tek, release: 0.8, amp: 1.5,  rate: 0.5
    sleep 1
    sample :bd_tek, release: 2, amp: 1,  rate: 0.5
    sleep 0.25
    sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
    sleep 0.25
    sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
    sleep 0.25
    sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
    sleep 0.25
  end
  sleep 15
  sample :bd_tek, release: 2, amp: 1,  rate: 0.5
  sleep 0.25
  sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
  sleep 0.25
  sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
  sleep 0.25
  sample :bd_tek, release: 0.1, amp: 1,  rate: 0.5
  sleep 0.25
end

live_loop :perc1, sync: :bd do
  use_bpm bpm
  sleep 0.5
  sample :drum_cymbal_pedal,amp: vol -0.5, rate: 1
  sleep 0.5
end

live_loop :perc2, sync: :bd do
  use_bpm bpm
  with_fx :reverb do
    sample
    sleep 1.5
    sample :elec_twip, release: 0.5, amp: 0.2
    sleep 1.5
  end
end


live_loop :main, sync: :bd do
  4.times do
    with_fx  :ixi_techno do
      use_bpm bpm
      3.times do
        use_synth :tech_saws
        play 38, release: 0.1,amp: vol
        play 50, release: 0.3,amp: vol
        sleep 0.25
        play 38, release: 0.1,amp: vol
        play 50, release: 0.3,amp: vol
        sleep 0.25
        play 45,release: 0.1,amp: vol
        play 57,release: 0.3,amp: vol
        sleep 0.25
        play 43,release: 0.1,amp: vol
        play 55,release: 0.3,amp: vol
        sleep 0.5
        play 43,release: 0.1,amp: vol
        play 55,release: 0.3,amp: vol
        sleep 0.25
        play 48,release: 0.1,amp: vol
        play 60,release: 0.3,amp: vol
        sleep 0.5
        play 46,release: 0.1,amp: vol
        play 58, release: 0.3,amp: vol
        sleep 0.75
        play 45,release: 0.1,amp: vol
        play 57, release: 0.3,amp: vol
        sleep 0.125
        play 43,release: 0.1,amp: vol
        play 55, release: 0.3,amp: vol
        sleep 0.125
        play 41,release: 0.1,amp: vol
        play 53, release: 0.3,amp: vol
        sleep 0.5
        play 43,release: 0.1,amp: vol
        play 55, release: 0.3,amp: vol
        sleep 0.5
      end
    end
    with_fx :ixi_techno do
      play 38, release: 0.1,amp: vol
      play 50, release: 0.1,amp: vol
      sleep 0.25
      play 38, release: 0.1,amp: vol
      play 50, release: 0.1,amp: vol
      sleep 0.25
      play 45,release: 0.1,amp: vol
      play 57,release: 0.2,amp: vol
      sleep 0.25
      play 43,release: 0.1,amp: vol
      play 55,release: 0.2,amp: vol
      sleep 0.5
      play 43,release: 0.1,amp: vol
      play 55,release: 0.2,amp: vol
      sleep 0.25
      play 48,release: 0.1,amp: vol
      play 60,release: 0.2,amp: vol
      sleep 0.5
      play 45,release: 0.1,amp: vol
      play 58, release: 0.2,amp: vol
      sleep 0.75
      play 45,release: 0.1,amp: vol
      play 57, release: 0.2,amp: vol
      sleep 0.125
      play 43,release: 0.1,amp: vol
      play 55, release: 0.2,amp: vol
      sleep 0.125
      play 41,release: 0.1,amp: vol
      play 53, release: 0.2,amp: vol
      sleep 0.5
      play 38,release: 0.1,amp: vol
      play 50, release: 0.5,amp: vol
      sleep 0.5
    end
  end
  sleep 16
end



live_loop :base, sync: :bd do
  use_bpm bpm
  15.times do
    8.times do
      3.times do
        with_fx :reverb, room: rrand(0,1) do
          use_synth :tb303
          cut = rrand(30, 90)
          play 26, release: rrand(0.01, 0.5),amp: vol -0.6,cutoff: cut
          play 38, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
          sleep 0.25
          play 26, release: rrand(0.01, 0.5),amp: vol -0.6,cutoff: cut
          play 38, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
          sleep 0.25
        end
      end
      
      with_fx :reverb, room: rrand(0,1)  do
        use_synth :tb303
        cut = rrand(30, 90)
        play 24, release: rrand(0.01, 0.5),amp: vol -0.6,cutoff: cut
        play 36, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
        sleep 0.5
        play 26, release: rrand(0.01, 0.5),amp: vol -0.6,cutoff: cut
        play 38, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
        sleep 1
        play 27, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
        play 41, release: rrand(0.01, 0.5),amp: vol -0.8,cutoff: cut
        sleep 1
      end
    end
  end
  sleep 1
end


