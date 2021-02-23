bpm = 130

live_loop :metro do
  use_bpm bpm
  sleep 4
end

live_loop :control, sync: :metro do
  use_bpm bpm
  tick
  cp = ['e2'].look
  tone = ['m9'].look
  sc = 'minor'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 16
end


set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 180, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 1

with_fx :reverb, room: 0.8, mix: 0.5 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.5 do
      
      
      use_random_seed [9].tick(:random_seed)
      
      use_bpm bpm
      ##| stop
      16.times do
        tick
        cp = get[:cp]
        sc = get[:sc]
        
        n = [0,0,0,1,2].shuffle.look
        n2 = [5,0,0,7, 0,0,0,1, 0,5,0,1, 0,0,0,1].look
        
        notes = scale(cp, sc).shuffle.look
        notes2 = scale(cp, sc).shuffle.look
        notes3 = scale(cp, sc)[n]
        notes4 = scale(cp, sc)[n2]
        num = rrand_i(1, 64)
        num2 = rrand_i(1,64)
        num3 = rrand_i(1, 8)
        
        if spread(16,16).rotate(num).look
          synth :sine,
            note: notes4 + 24,
            cutoff: (range 30, 120).shuffle.look,
            pan: (range -1, 1, 0.1).mirror.look,
            amp: 1,
            release: 0.1
        end
        
        with_fx :compressor, threshold: 1 do
          with_fx :lpf, cutoff: 70 do
            with_fx :eq, low: 1 do
              if spread(16,num2).look
                synth :tb303,
                  note: notes3,
                  res: (range 0, 0.9, 0.01).mirror.look,
                  cutoff: 130,
                  cutoff: (range 90, 130, 0.5).mirror.look,
                  wave: 0,
                  depth: 0,
                  divisor: 0,
                  amp: 2,
                  release: 0.18
              end
            end
          end
        end
        
        if spread(num3,num2).rotate(num2).look
          synth :zawa, note: notes + 36, amp: 0.5,
            cutoff: 130, release: 0.25, attack: 0.01, depth: 0
        end
        ##| end
        sleep 0.25
      end
    end
  end
end



with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    with_fx :compressor, threshold: 0.5 do
      ##| stop
      use_bpm bpm
      
      cp = get[:cp]
      tone = get[:tone]
      
      notes = chord(cp, tone, num_octaves: 3, chord_invert: 1)
      
      ##| with_fx :distortion, distort: 0.5 do
      with_fx :slicer, phase: [0.25].choose do
        with_fx :ixi_techno, phase: dice(16) do
          synth :sine,
            amp: 0.5,
            depth: 0,
            note: notes + [0,12].choose,
            sustain: 16
        end
      end
      ##| end
      
      sample :mehackit_phone2, amp: 0.3, rate: -1
      sleep 16
    end
  end
end

with_fx :reverb, room: 0.6 do
  live_loop :drum, sync: :metro do
    ##| stop
    use_bpm bpm
    
    with_fx :compressor, threshold: 2 do
      with_fx :bpf, centre: 50, res: 0.1 do
        sample :bd_klub, amp: 4, beat_stretch: 0.25, rate: 0.25,release: 0.25, sustain: 0.1, attack: 0 if spread(4,16).tick
        ##| sample :bd_klub,amp: 4, sustain: 0.25, rate: 0.8,cutoff: 90 if spread(6,32).rotate(13).look
      end
    end
    
    
    
    with_fx :compressor, threshold: 1 do
      with_fx :hpf, cutoff: 100 do
        sample :elec_cymbal, amp: 1.5, finish: 0.1, rate: 0.25, beat_stretch: 0.15, cutoff: 90 if spread(1,4).rotate(2).look
      end
      
      sample :sn_generic, amp: 0.1, sustain: 0.25,
        release: 0.1, cutoff: 90 if spread(1,16).rotate(1).look
    end
    
    
    sleep 0.25
  end
  ##| stop
end






