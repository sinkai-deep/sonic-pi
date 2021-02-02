
set :bpm, 128

live_loop :metro do
  use_bpm get[:bpm]
  sleep 4
end

live_loop :control, sync: :metro do
  cp = ['e2'].tick(:cp)
  tone = ['m'].tick(:tn)
  sc = 'minor'
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 8
end

set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 160, lpf_slide: 2
set_mixer_control! amp: 0, amp_slide: 7

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.5 do
      
      16.times do
        use_random_seed 4872
        
        use_bpm get[:bpm]
        ##| stop
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
        
        if spread(12,16).rotate(5).tick(:fm1)
          synth :fm,
            note: notes4 + 12,
            depth: 0,
            amp: 1,
            release: 0.25
        end
        
        if spread(26, 32).rotate(num).tick(:tb1)
          synth :tb303,
            note: notes4 ,
            res: (range 0, 0.9, 0.01).mirror.look(:tb1),
            cutoff: (range 50, 120, 1).shuffle.look(:tb1),
            wave: 1,
            amp: 0.6,
            release: 0.25,
            susatain: 0.25
        end
        
        if spread(10,16).rotate(num2).tick(:tb)
          synth :tb303, note: notes2-12, amp: 0.3,
            cutoff: 120, release: 0.25, depth: 1
        end
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
    
    notes = chord(cp, tone, num_octaves: 3, chord_invert: 0)
    
    if one_in(2)
      with_fx :ixi_techno, phase: dice(8) do
        synth :fm,
          amp: 0.2,
          depth: dice(20),
          note: notes,
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
      with_fx :eq, amp: 1.4, low_shelf: -0.4, low: -0.8, mid: -1, high: 0.7 do
        sample :bd_haus, amp: 2, rate: 1 if spread(4,16).tick
        sample :bd_haus,amp: 0.7, sustain: 0.25, rate: 0.8,cutoff: 90 if spread(12,32).rotate(15).look
      end
    end
    
    with_fx :eq, amp: 0.8,low: -2, high: -0.2 do
      sample :drum_cymbal_soft,amp: 0.2, sustain: 0.1, release: 0.2 if spread(6,16).rotate(3).look
      sample :drum_cymbal_closed,amp: 0.1,sustain: 0.1, release: 0.2 if spread(16,16).rotate(0).look
    end
    
    sleep 0.25
  end
  ##| stop
end






