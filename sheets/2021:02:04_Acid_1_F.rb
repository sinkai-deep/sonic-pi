
set :bpm, 135

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['c3'].tick(:cp)
  tone = ['m'].tick(:tn)
  sc = 'iwato'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 16
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 160, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 0

with_fx :reverb, room: 0.2 do
  live_loop :ground, sync: :metro do
    4.times do
      
      use_random_seed rrand_i(0,99999999)
      
      use_bpm get[:bpm]
      
      ##| stop
      
      cp = get[:cp]
      sc = get[:sc]
      
      n = [0,0,0,1].look(:n2)
      n2 = [5,0,0,7, 3,0,0,1, 0,5,0,1, 0,0,0,1].tick(:n2)
      
      notes = scale(cp, sc).shuffle.tick(:notes)
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      notes3 = scale(cp, sc)[n]
      notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(0, 64)
      num2 = rrand_i(0,64)
      
      
      ##| with_fx :eq, high: 1.5, high_shelf: 0 do
      ##|   if spread(16,16).rotate(num2).tick(:fm1)
      ##|     synth :fm,
      ##|       note: notes4 + choose([24,36]),
      ##|       depth: 0,
      ##|       divisor: 2,
      ##|       amp: 0.6, amp_slide: 16,
      ##|       release: 0.1
      ##|   end
      
      
      if spread(24, 32).rotate(7).tick(:tb1)
        synth :tb303,
          note: notes3,
          res: (range 0, 0.9, 0.05).mirror.look(:tb1),
          cutoff: (range 60, 80, 1).mirror.look(:tb1),
          wave: 0,
          amp: 0.5, amp_slide: 16,
          release: 0.25,
          susatain: 0.25
      end
      
      ##| with_fx :eq, high: 1, low_shelf: 1, high_shelf: 0 do
      if spread(26, 32).rotate(num).tick(:tb1)
        synth :tb303,
          note: notes2-12,
          res: (range 0, 0.9, 0.05).mirror.look(:tb1),
          cutoff: (range 50, 120, 1).mirror.look(:tb1),
          wave: 0,
          amp: 1.5, amp_slide: 16,
          release: 0.15
      end
    end
    sleep 0.25
    ##| stop
  end
end



with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone, num_octaves: 2)
    
    
    if one_in(3)
      with_fx :distortion, distort: 0.2 do
        with_fx :ixi_techno, phase: rrand(0, 4) do
          synth :prophet,
            amp: 0.5,
            res: 0,
            note: notes-12,
            release: 16
        end
      end
    end
    
    with_fx :eq, high: 1 do
      sample :ambi_choir, amp: 2,amp_slide: 16, rate: -0.1, sustain: 16
    end
    
    sleep 16
  end
end


live_loop :bass, sync: :metro do
  ##| stop
  use_bpm get[:bpm]
  cp = get[:cp]
  sc = get[:sc]
  
  notes = scale(cp, sc)[0]
  with_fx :eq, low: 0.5, amp: 0.3 do
    with_fx :distortion, distort: 0.9 do
      with_fx :ixi_techno, phase: dice(16), mix: 0.2 do
        synth :prophet,
          note: notes -12,
          amp: 0.3,
          cutoff: 120,
          sustain: 16,
          res: 0
      end
    end
  end
  sleep 16
end


with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    
    ##| stop
    use_bpm get[:bpm]
    
    
    with_fx :lpf, cutoff: 80, cutoff_slide: 16 do
      with_fx :eq, amp: 5, low_shelf: -1, low: -0.8, mid: -0.6, high: 0.5 do
        sample :bd_haus, amp: 4, rate: 1 if spread(1,4).tick
        ##| sample :bd_haus,amp: 3, sustain: 0.25, rate: 0.7,cutoff: 90 if spread(1,8).rotate(5).look
      end
    end
    with_fx :eq, amp: 3,low: -2, high: -0.2 do
      sample :drum_cymbal_soft,amp: 1, sustain: 0.1, release: 0.2 if spread(2,8).rotate(2).look
      sample :drum_cymbal_closed,amp: 0.4,sustain: 0.1, release: 0.2 if spread(16,16).rotate(2).look
    end
    
    ##| with_fx :eq, amp: 2,low: -1, high: -0.1 do
    ##|   sample :drum_cymbal_soft,amp: 0.3, sustain: 0.1, release: 0.1 if spread(1,4).rotate(3).look
    ##| end
    ##| stop
    sleep 0.25
  end
end







