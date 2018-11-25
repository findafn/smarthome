make:
	HCopy -T 1 -C config -S scp/codetrain.scp
evaluate:
	HVite -C config1 -H hmm15/macros -H hmm15/hmmdefs -S scp/train.scp -l '*' -i recout_train.mlf -w wdnet -p 0.0 -s 5.0 dictionary.txt tiedlist
	HResults -I data/trainref.mlf tiedlist recout_train.mlf
	HVite -C config1 -H hmm15/macros -H hmm15/hmmdefs -S scp/test.scp -l '*' -i recout.mlf -w wdnet -p 0.0 -s 5.0 dictionary.txt tiedlist
	HResults -I data/testref.mlf tiedlist recout.mlf
encode:
	HCopy -A -D -T 1 -C config -S scp/codetrain.scp
train:
	HCompV -A -D -T 1 -C config3 -f 0.01 -m -S scp/train.scp -M hmm0 proto
	python generate_hmm0.py
	HERest -A -D -T 1 -C config3 -I data/phones0.mlf -t 250.0 150.0 1000.0 -S scp/train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 data/monophones0
	HERest -A -D -T 1 -C config3 -I data/phones0.mlf -t 250.0 150.0 1000.0 -S scp/train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 data/monophones0
	HERest -A -D -T 1 -C config3 -I data/phones0.mlf -t 250.0 150.0 1000.0 -S scp/train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 data/monophones0
	cp hmm3/macros hmm4/
	python generate_hmm4.py
	HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed data/monophones1
	HERest -A -D -T 1 -C config3 -I data/phones1.mlf -t 250.0 150.0 3000.0 -S scp/train.scp -H hmm5/macros -H hmm5/hmmdefs -M hmm6 data/monophones1
	HERest -A -D -T 1 -C config3 -I data/phones1.mlf -t 250.0 150.0 3000.0 -S scp/train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 data/monophones1
	HVite -A -D -T 1 -l '*' -o SWT -b SENT-END -C config3 -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I data/words.mlf -S scp/train.scp dictionary.txt data/monophones1
	HERest -A -D -T 1 -C config3 -I aligned.mlf -t 250.0 150.0 3000.0 -S scp/train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8 data/monophones1
	HERest -A -D -T 1 -C config3 -I aligned.mlf -t 250.0 150.0 3000.0 -S scp/train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9 data/monophones1
	HLEd -A -D -T 1 -n data/triphones1 -l '*' -i data/wintri.mlf mktri.led aligned.mlf
	julia mktrihed.jl data/monophones1 data/triphones1 mktri.hed
	# on going step 9