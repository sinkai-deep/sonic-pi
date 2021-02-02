
set :bpm, 128

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['c3'].tick(:cp)
  tone = ['m7'].tick(:tn)
  sc = 'minor_pentatonic'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 8
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 120, lpf_slide: 16
set_mixer_control! amp: 1, amp_slide: 1

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.5 do
      
      
      use_random_seed 0
      
      use_bpm get[:bpm]
      ##| stop
      16.times do
        cp = get[:cp]
        sc = get[:sc]
        
        n = 0
        n2 = [5,0,0,7, 0,0,0,1, 0,5,0,1, 0,0,0,1].tick(:n2)
        
        notes = scale(cp, sc).shuffle.tick(:notes)
        notes2 = scale(cp, sc).shuffle.tick(:notes2)
        notes3 = scale(cp, sc)[n]
        notes4 = scale(cp, sc)[n2]
        num = rrand_i(0, 64)
        num2 = rrand_i(0,64)
        
        if spread(16,32).rotate(num).tick(:fm1)
          synth :fm,
            note: notes4-12,
            depth: 1,
            amp: 1,
            release: 0.25
        end
        
        if spread(7,16).tick(:tb1)
          synth :tb303,
            note: notes4,
            res: (range 0, 0.9, 0.01).mirror.tick(:res),
            wave: 0,
            amp: 0.1,
            release: 0.25,
            susatain: 0.25
        end
        
        if spread(8,64).rotate(num2).tick(:tb)
          synth :fm, note: notes2+12, amp: 0.9,
            cutoff: 120, release: 0.25, depth: 1
        end
        ##| end
        sleep 0.25
      end
    end
  end
end



with_fx :reverb, room: 1 do
  live_loop :chords, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    cp = get[:cp]
    tone = get[:tone]
    
    notes = chord(cp, tone, num_octaves: 2, chord_invert: 1)
    
    with_fx :ixi_techno, phase: dice(16) do
      synth :fm,
        amp: 0.1,
        depth: 1,
        note: notes,
        sustain: 16
      sleep 16
    end
  end
end


with_fx :reverb, room: 0.6 do
  live_loop :drum, sync: :metro do
    ##| stop
    use_bpm get[:bpm]
    
    with_fx :lpf, cutoff: 100 do
      sample :bd_klub,amp: 0.8, sustain: 0.25, rate: 1 if spread(4,16).tick
      sample :bd_klub,amp: 0.7, sustain: 0.25, rate: 0.8,cutoff: 90 if spread(6,32).rotate(13).look
    end
    
    with_fx :hpf, cutoff: 100 do
      sample :bd_mehackit,amp: 0.1, sustain: 0.25, rate: 0.8 if spread(1,4).rotate(2).look
      ##| sample :bd_haus,amp: 0.5, sustain: 0.2, rate: 0.8 if spread(3,16).rotate(4).look
    end
    
    
    with_fx :compressor, amp: 0.5 do
      sample :drum_cymbal_closed, amp: 2,rate: 1,sustain: 0.1, decay: 0, cutoff: 90 if spread(2,8).rotate(6).look
      ##| sample :drum_tom_lo_soft, amp: 1, sustain: 0.1, release: 0.1 if spread(10,32).rotate(1).look
    end
    
    
    sleep 0.25
  end
  ##| stop
end






