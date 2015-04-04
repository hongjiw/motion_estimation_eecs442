function rc_prep(data_path, bucket_size)
[data, label, seg] = collect_data(data_path, bucket_size);
fprintf('Finally collected %d data samples from %s\n', size(label,2), data_path);

%convert to hdf5 fomat
data_hdf5 = reshape(data, size(data,1), 2, 1, size(data,2) / 2);
label_hdf5 = label;
train_size = sum(seg(1:end-2), 2);
train_data_hdf5 = data_hdf5(:,:,:,1:train_size);
train_label_hdf5 = label_hdf5(:,1:train_size);
test_data_hdf5 = data_hdf5(:,:,:,train_size+1:end);
test_label_hdf5 = label_hdf5(:,train_size+1:end);

%write to hdf5
hdf5_train_file = [data_path, '/train.h5'];
hdf5_test_file = [data_path, '/test.h5'];
startloc=struct('dat',[1,1,1,1], 'lab', [1,1]);
store2hdf5(hdf5_train_file, train_data_hdf5, train_label_hdf5, true, startloc, size(train_label_hdf5,2)); 
store2hdf5(hdf5_test_file, test_data_hdf5, test_label_hdf5, true, startloc, size(test_label_hdf5,2)); 

%create list file
FILE=fopen([data_path ,'/', 'train_list.txt'], 'w');
fprintf(FILE, '%s', hdf5_train_file);
fclose(FILE);
FILE=fopen([data_path, '/', 'test_list.txt'], 'w');
fprintf(FILE, '%s', hdf5_test_file);
fclose(FILE);
end