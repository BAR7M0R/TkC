function evm = evm_measure(qamSymbols_out,qamSymbols_ref,P)

err_vec=abs(qamSymbols_out-qamSymbols_ref).^2;
err=mean(err_vec);
evm=10*log10(err/P);
end

