function write_femfile(bodypart)
    
    fid = fopen('test.melm','w');
	comment{1}='element file test by zty';
    write_comment(fid,comment);
    
    fl=size(bodypart.v_phi,3);
    n_sp=size(bodypart.v_phi,1);
    num_point=fl*n_sp*4+fl;
    num_face=n_sp*4*fl+n_sp*4*2*(fl-1);
    num_element=n_sp*4*(fl-1);
    
    v=[];
    f3b=[];
    f4b=[];
    f4sd=[];
    f4fr=[];
    ele1=[];
    ele2=[];
    ele3=[];
    ele4=[];
    
    % make the first floor of v and f
    v_phi=bodypart.v_phi(:,:,1);
    vic=mean(v_phi);
    for j=1:4
        ps=v_phi-(v_phi-repmat(vic,n_sp,1))*(j-1)*0.25;
        v=[v;ps];      % v expands downward
    end
    v=[v;vic];        % 121 vertex every floor
    fc1=1:n_sp;
    fc2=mod(fc1,n_sp)+1;
    for j=1:3     % outside 3 layers
        ftemp=[fc1;fc1+30;fc2+30;fc2];
        f4b=[f4b ftemp];
        fc1=fc1+30;
        fc2=fc2+30;
    end
    f3b=[f3b fc1;repmat(n_sp*4+1,1,n_sp);fc2];
    
    
    num_pfv=n_sp*4+1;   % 每一层的点的数量
    
    %这里以后可以再参数化
    num_1stf=120;   
    num_pff=360;    %每一层面的数量
    % and the else
    for i=2:fl
        v_phi=bodypart.v_phi(:,:,i);
        vic=mean(v_phi);
        for j=1:4
            ps=v_phi-(v_phi-repmat(vic,n_sp,1))*(j-1)*0.25;
            v=[v;ps];      % v expands downward
        end
        v=[v;vic];        % 121 vertex every floor
        fc1=(1:n_sp)+num_pfv*i;
        fc2=mod(fc1,n_sp)+1+num_pfv*i;
        for j=1:3    % 处理外面3层
            f4bt=[fc1;fc1+n_sp;fc2+n_sp;fc2];
            f4b=[f4b f4bt];
            f4sdt=[fc1;fc1-num_pfv;fc2-num_pfv;fc2];
            f4sd=[f4sd f4sdt];
            f4frt=[fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv];
            f4fr=[f4fr f4frt];
            fc1=fc1+30;
            fc2=fc2+30;
        end
        % 处理内部核心层
        f3bt=[fc1;repmat((n_sp*4+1)*i,1,n_sp);fc2];
        f3b=[f3b f3bt];
        f4sdt=[fc1;fc1-num_pfv;fc2-num_pfv;fc2];
        f4sd=[f4sd f4sdt];
        f4frt=[fc1;fc1+n_sp;fc1+n_sp-num_pfv;fc1-num_pfv];
        f4fr=[f4fr f4frt];
        
        ec1=(1:n_sp)+num_pff*(i-1);
        ec2=ec1+num_1stf;
        ec3=ec2+num_1stf;
        circle_offset=mod(1:30,30)-(1:30);
        elem_seq6=[ec1;ec1+num_pff;ec2;ec2+30;ec3;ec3+circle_offset+1];
        elem_seq5=[ec1+90;ec1+num_pff+90;ec2+90;ec3+90;ec3+90+circle_offset+1];
        ele1=[ele1 elem_seq6];
        ele2=[ele2 elem_seq6+30];
        ele3=[ele3 elem_seq6+60];
        ele4=[ele4 elem_seq5];
    end
    
    % T：假设f3 与 f4 都处理正确
    % 那么f3 应该是每一层有30个面
    % f4 每一层有90个底面 120个侧面和120个正面
    % f写入的顺序是 底面 右侧面 前侧面
    % 第一、二、三层元素应该取上下层的底面和左右侧面以及前后侧面
    % 最后一层元素应该取上下层、前后侧面和右侧面
    % 假设全部格式书写正确
    for i=1:size(v,1)
        fprintf(fid,'v %f %f %f\n',v(i,1),v(i,2),v(i,3));
    end
    
    % 写下第一层的底面
    for i=1:90
        fprintf(fid,'f %d %d %d %d\n',f4b(1,i),f4b(2,i),f4b(3,i),f4b(4,i));
    end
    for i=1:30
        fprintf(fid,'f %d %d %d\n',f3b(1,i),f3b(2,i),f3b(3,i));
    end
    %写下剩余的面
    for i=1:fl-1
        sdst=(120*(i-1)+1);
        sded=(120*i);
        for j=sdst:sded
            fprintf(fid,'f %d %d %d %d\n',f4sd(1,j),f4sd(2,j),f4sd(3,j),f4sd(4,j));
        end
        for j=sdst:sded
            fprintf(fid,'f %d %d %d %d\n',f4fr(1,j),f4fr(2,j),f4fr(3,j),f4fr(4,j));
        end
        b4st=(90*i+1);
        b4ed=90*(i+1);
        for j=b4st:b4ed
            fprintf(fid,'f %d %d %d %d\n',f4b(1,j),f4b(2,j),f4b(3,j),f4b(4,j));
        end
        b3st=(30*i+1);
        b3ed=(30*(i+1));
        for j=b3st:b3ed
            fprintf(fid,'f %d %d %d\n',f3b(1,j),f3b(2,j),f3b(3,j));
        end
    end
    
    % layer 1
    fprintf(fid,'Layer 1\n');
    for i=1:size(ele1,2)
        fprintf(fid,'el %d %d %d %d %d %d\n',ele1(1,i),ele1(2,i),ele1(3,i),ele1(4,i),ele1(5,i),ele1(6,i));
    end
    
    fclose(fid);
end

function write_comment(fid,comments)
    for i=1:length(comments)
        fprintf(fid,'# %s\n',comments{i});
    end
end