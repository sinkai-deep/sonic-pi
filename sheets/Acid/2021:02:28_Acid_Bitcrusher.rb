bpm = 140

live_loop :metro do
  use_bpm bpm
  sleep 4
end

live_loop :control, sync: :metro do
  use_bpm bpm
  tick
  cp = ['f2'].shuffle.look
  tone = ['m'].look
  sc = ['iwato'].look
  set :cp, cp
  set :tone, tone
  set :sc, sc
  sleep 4
end


set_mixer_control! hpf: 0, hpf_slide: 2
set_mixer_control! lpf: 180, lpf_slide: 4
set_mixer_control! amp: 1, amp_slide: 1

with_fx :reverb, room: 0.5, mix: 0.5 do
  live_loop :ground, sync: :metro do
    with_fx :compressor, amp: 0.6, threshold: 0.5 do
      with_fx :lpf, cutoff: (range 90, 130, 1).mirror.look do
        with_fx :eq, low: 0.4, mid: 0.5 do
          
          cp = get[:cp]
          sc = get[:sc]
          rn = [0,0,0,1].tick(:random_seed)
          use_random_seed [rn].look(:random_seed)
          
          use_bpm bpm
          ##| stop
          1.times do
            tick
            bits = (range 4, 16, 0.5).mirror.look
            with_fx :bitcrusher, bits: 4 do
              
              n = [0,0,0,1,2].look
              n2 = [5,0,0,7, 0,0,0,1, 0,5,0,1, 0,0,0,1].look
              
              notes = scale(cp, sc).shuffle.look
              notes2 = scale(cp, sc).shuffle.look
              notes_n = scale(cp, sc)[n]
              notes_n2 = scale(cp, sc)[n2]
              num = rrand_i(1, 64)
              num2 = rrand_i(1,64)
              num3 = rrand_i(1, 8)
              
              with_fx :distortion, distort: 0 do
                if spread(16,16).rotate(num2).look
                  synth :supersaw,
                    note: notes_n + [12,24,36].choose,
                    amp: [0,0.5].choose,
                    pan: (range -1, 1, 0.1).shuffle.look,
                    release: [0.1, 0.18, 0.15].choose,
                    attack: 0
                end
              end
              
              if spread(16,16).rotate(num2).look
                synth :tb303,
                  note: notes_n + [0].choose,
                  amp: [1.5].choose,
                  res: (range 0.1, 0.9, 0.01).mirror.look,
                  cutoff: (range 70, 120, 1).mirror.look,
                  pan: (range -1, 1, 0.1).mirror.look,
                  ##| release: [0.25, 0.18, 0.25, 0.25, 0.1, 0.1].choose,
                  release: 0.25,
                  attack: 0,
                  wave: 0
              end
              
              if spread(num3,8).rotate(num2).look
                synth :supersaw,
                  note: notes + [0, 36].choose,
                  amp: [0.8].choose,
                  res: (range 0.4, 0.9, 0.01).mirror.look,
                  cutoff: (range 90, 120).shuffle.look,
                  pan: (range -1, 1, 0.1).mirror.look,
                  release: [0.1, 0.18, 0.2].choose,
                  attack: 0,
                  wave: 1
              end
              
              if spread(1, 16).look
                synth :supersaw,
                  note: notes_n + [0, 0, 0, 1].look,
                  amp: 0.4,
                  sustain: 4
              end
              
              sleep 0.25
            end
          end
        end
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
      
      notes = chord(cp, tone, num_octaves: 3, chord_invert: 2)
      
      ##| with_fx :distortion, distort: 0.1 do
      with_fx :slicer, phase: [0.25, 0.75].choose do
        with_fx :ixi_techno, phase: dice(32) do
          synth :supersaw,
            amp: 0.9,
            note: notes,
            attack: 1,
            sustain: 16
        end
      end
      ##| end
      
      
      sleep 16
    end
  end
end

with_fx :reverb, room: 1 do
  live_loop :mehackit, sync: :metro do
    stop
    use_bpm bpm
    with_fx :bitcrusher, bits: 4 do
      with_fx :distortion, distort: 0.1 do
        with_fx :hpf, cutoff: 30 do
          s = (['mehackit_phone1', 'mehackit_phone2', 'mehackit_phone3', 'mehackit_phone4']).choose
          if one_in(3)
            sample s, amp: 0.1, beat_stretch: 2, rate: [-4, -2, -1, -0.5, 0.5, 0.6, 0.7, 2, 4].choose
          end
          sleep 4
        end
      end
    end
  end
end

##| set_mixer_control! lpf: 80, lpf_slide: 4

with_fx :reverb, room: 0.6 do
  live_loop :drum, sync: :metro do
    ##| stop
    use_bpm bpm
    
    with_fx :compressor, threshold: 3 do
      with_fx :bpf, centre: 50, res: 0.4 do
        sample :bd_haus,
          amp: 4.5,
          sustain: 0.25,
          release: 0.2,
          attack: 0.01,
          decay: 0 if spread(1,4).tick
        sample :bd_klub,
          amp: 3,
          sustain: 0.25,
          rate: 0.8,
          cutoff: 90 if spread(1,8).rotate(4).look
      end
    end
    
    
    with_fx :compressor, threshold: 1 do
      with_fx :hpf, cutoff: 100 do
        sample :elec_cymbal,
          amp: 3.5,
          finish: 0.1,
          rate: 0.25,
          beat_stretch: 0.15,
          cutoff: 90 if spread(8,16).rotate(2).look
      end
      
      sample :sn_generic,
        amp: 1.8,
        sustain: 0.2,
        release: 0.1,
        beat_stretch: 0.1,
        cutoff: 90 if spread(4,16).rotate(4).look
    end
    
    sample :drum_cymbal_open,
      amp: 1.5,
      cutoff: 100,
      release: 0.15,
      beat_stretch: 0.25 if spread(5, 16).look
    
    sleep 0.25
  end
  ##| stop
end



0-------------  50  ------------130


