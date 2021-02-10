bpm = 124

live_loop :metro do
  use_bpm bpm
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 4
set_mixer_control! lpf: 130, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 2

with_fx :reverb, room: 1 do
  live_loop :ground, sync: :metro do
    ##| with_fx :reverb, room: 0.6 do
    tick
    use_bpm bpm
    
    1.times do
      ##| stop
      cp = ['e4'].look
      puts cp
      sc = ['minor'].look
      n = scale(cp, sc)[0]
      notes = n + [0, 7, 8, 10, 8, 7, 5, 7].look
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      ##| notes3 = scale(cp, sc)[n]
      ##| notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(1, 64)
      num2 = rrand_i(1,64)
      num3 = rrand_i(1,64)
      use_random_seed dice(99999)
      
      with_fx :distortion, amp: 1, distort: 0 do
        with_fx :eq, high: 0  do
          synth :fm,
            note: notes,
            depth: 1,
            divisor: 1,
            attack: 0,
            amp: 1,
            release: 1
        end
      end
      sleep 1
    end
    ##| end
    # stop
    ##| end
  end
end

with_fx :reverb, room: 0.5 do
  live_loop :bass, sync: :metro do
    use_bpm bpm
    tick
    use_random_seed rrand_i(0, 9999999)
    
    ##| stop
    with_fx :lpf, cutoff: 100 do
      if spread(16, 16).rotate( dice(16) ).look
        synth :tb303,
          note: [:e2, :e3].choose,
          res: (range 0, 0.9, 0.1).mirror.look,
          cutoff: (range 50, 130, 1).mirror.look,
          attack: 0,
          amp: 2,
          release: 0.25
      end
    end
    
    
    
    n = dice(64)
    n2 = dice(64)
    n3 = dice(64)
    
    ##| with_fx :lpf, cutoff: 100 do
    ##|   if spread(n, n2).rotate(n3).look
    ##|     synth :fm,
    ##|       note: scale(:e3, :minor_pentatonic).shuffle.look,
    ##|       res: (range 0, 0.9, 0.05).mirror.look,
    ##|       cutoff: (range 50, 130, 1).mirror.look,
    ##|       attack: 0,
    ##|       amp: 1.3,
    ##|       release: 0.25
    ##|   end
    ##| end
    
    sleep 0.25
  end
end

with_fx :reverb, room: 1, mix: 0.5 do
  live_loop :chords, sync: :metro do
    ##| stop
    use_bpm bpm
    tick
    
    cp = 'e2'
    tone = ['m'].look
    sc = 'minor'
    
    n = [0].look
    notes = chord(cp, tone)
    num = 16
    ##| if one_in(1)
    with_fx :lpf, cutoff: 100 do
      with_fx :slicer, phase: [0.25,0.75].choose do
        with_fx :ixi_techno, phase: dice(16) do
          synth :fm,
            amp: 1,
            depth: 0,
            attack: 0,
            note: notes,
            release: num,
            sustain: num*0.9
        end
      end
    end
    sleep num
    ##| stop
  end
end

with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    
    ##| stop
    use_bpm bpm
    tick
    with_fx :bpf, centre: 50, res: 0.6 do
      with_fx :eq, amp: 2, low: -0.1, mid: 0.2, high: 1 do
        sample :bd_tek, amp: 3, rate: 1, attack: 0 if spread(1,4).look
      end
    end
    
    ##| stop
    sleep 0.25
  end
end

with_fx :reverb, room: 0.1 do
  live_loop :pc, sync: :metro do
    ##| stop
    use_bpm bpm
    tick
    ##| num = dice(8)
    
    with_fx :lpf, cutoff: 90 do
      with_fx :bpf, centre: 100, res: 0.1 do
        with_fx :eq, amp: 2,low: -1, high: 0.2, mid: 0.3 do
          sample :drum_snare_hard, amp: 1 if spread(2 ,8).rotate(2).look
        end
      end
    end
    
    if one_in(4)
      with_fx :bpf, centre: 90, res: 0.5 do
        with_fx :eq, low: 2, mid: 0.2, high: 1, amp: 3 do
          n = [3, 4, 5, 6, 10].choose
          sample :drum_tom_mid_soft, rate: 1 if spread(n, 32).rotate(0).look
          sample :drum_tom_mid_soft, rate: 1 if spread(n, 32).rotate(1).look
          sample :drum_tom_hi_soft, rate: 1 if spread(n, 32).rotate(2).look
        end
      end
    end
    
    sleep 0.25
  end
end








