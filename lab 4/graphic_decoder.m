function data_out_uint8=graphic_decoder(bit_received)

data_bin=reshape(bit_received,8,length(bit_received)/8).';
data_int=bi2de(data_bin,'right-msb');
data_out=(reshape(data_int,512,512,[]));
data_out_uint8=uint8(data_out);
figure
imshow(data_out_uint8)
end
