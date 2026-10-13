clear all;

source_path = '\'; % Data file folder e.g. 'G:\AST-TB\Data\'

img_intst = zeros(600,60);

f = 1;

for a = 1:1:6
    index = (a-1)*10;
    
    for b = 1:1:10
    
        folder1 = num2str(a,'%01d'); %
        folder2 = num2str(b,'%01d');
        str = [source_path, folder1, '\Processed\', folder2, '\']; %
        path = join(str);
        imges = dir([path '*.tif']);
        imge_num = length(imges);
        shapes = size(imread([imges(1).folder '/' imges(1).name]));
        all_images = zeros(imge_num, shapes(1), shapes(2));

        for i = 1:1:imge_num
            img = imread([imges(i).folder '/' imges(i).name]);
            all_images(i,:,:) = img;
        end

        img_mean = mean(all_images,[2,3]); % get intensity of each frame

        f = index + b;

        img_intst(:,f) = img_mean;
        
        [a, b]    
        
    end
    
end

img_intst_mean = mean(img_intst);

m=1;

for c = 1:60
    
    if c==m*10
        
        img_intst_mean_1(1,m)=img_intst_mean(c-9);
        img_intst_mean_1(2,m)=img_intst_mean(c-8);
        img_intst_mean_1(3,m)=img_intst_mean(c-7);
        img_intst_mean_1(4,m)=img_intst_mean(c-6);
        img_intst_mean_1(5,m)=img_intst_mean(c-5);
        img_intst_mean_1(6,m)=img_intst_mean(c-4);
        img_intst_mean_1(7,m)=img_intst_mean(c-3);
        img_intst_mean_1(8,m)=img_intst_mean(c-2);
        img_intst_mean_1(9,m)=img_intst_mean(c-1);
        img_intst_mean_1(10,m)=img_intst_mean(c);
        m=m+1;
        
    end
    
end

for d = 1:6
    
    for e = 1:10
        
        img_intst_mean_2(e,d) = img_intst_mean_1(e,d)/img_intst_mean_1(1,d);
        
    end
    
end