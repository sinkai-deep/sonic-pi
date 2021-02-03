
set :bpm, 128

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['f2'].tick(:cp)
  tone = ['m'].tick(:tn)
  sc = 'minor_pentatonic'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 16
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 160, lpf_slide: 3
set_mixer_control! amp: 1, amp_slide: 1

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    64.times do
      
      use_random_seed 2077
      
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
      
      with_fx :distortion, amp: 0.5, distort: 0.3 do
        with_fx :eq, high: 1, high_shelf: 1 do
          if spread(55,64).rotate(num).tick(:fm1)
            synth :fm,
              note: notes + 12,
              depth: 1,
              divisor: 0,
              amp: 5, amp_slide: 16,
              release: 0.25
          end
        end
      end
      
      if spread(30, 32).rotate(num).tick(:tb1)
        synth :tb303,
          note: notes3 -24,
          res: 0.9,
          res: (range 0, 0.9, 0.05).mirror.look(:tb1),
          cutoff: (range 90, 120, 1).mirror.look(:tb1),
          wave: 0,
          amp: 0.3,
          release: 0.25,
          susatain: 0.25
      end
      
      with_fx :eq, high: 1, low_shelf: 1, high_shelf: 1 do
        if spread(30, 32).rotate(num2).tick(:tb1)
          synth :tb303,
            note: notes4 -24,
            res: (range 0, 0.3, 0.01).mirror.look(:tb1),
            cutoff: (range 50, 120, 1).mirror.look(:tb1),
            wave: 0,
            amp: choose([1, 1]),
            release: 0.15,
            susatain: 0.15
        end
      end
      
      if spread(10,16).rotate(num2).tick(:tb)
        synth :prophet, note: notes2-12, amp: 0.3,
          cutoff: 120, release: 0.55
      end
      sleep 0.25
      ##| stop
    end
  end
end



with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone, num_octaves: 5, chord_invert: 0)
    
    if one_in(1)
      with_fx :ixi_techno, phase: dice(16) do
        synth :prophet,
          amp: 3,
          res: 0,
          note: notes-12,
          release: 16
      end
    end
    sleep 16
  end
end


with_fx :reverb, room: 0 do
  live_loop :drum, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    with_fx :lpf, cutoff: 70 do
      with_fx :eq, amp: 8, low_shelf: -0.4, low: -0.8, mid: -1, high: 0.7 do
        sample :bd_haus, amp: 5, rate: 1 if spread(4,16).tick
        ##| sample :bd_haus,amp: 3, sustain: 0.25, rate: 0.8,cutoff: 90 if spread(12,32).rotate(15).look
      end
    end
    
    with_fx :eq, amp: 3,low: -2, high: -0.2 do
      sample :drum_cymbal_soft,amp: 0.2, sustain: 0.1, release: 0.2 if spread(4,16).rotate(2).look
      sample :drum_cymbal_closed,amp: 0.1,sustain: 0.1, release: 0.2 if spread(16,16).rotate(0).look
    end
    
    with_fx :eq, amp: 3,low: -1, high: -0.1 do
      sample :drum_cymbal_soft,amp: 0.3, sustain: 0.1, release: 0.1 if spread(1,4).rotate(2).look
    end
    
    sleep 0.25
  end
  ##| stop
end






