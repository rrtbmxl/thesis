Screen('Preference', 'SkipSyncTests', 1); % 跳过同步性测试

% 清理窗口和变量
sca;
close all;
clearvars;

answer = inputdlg({'序号'},'信息',1,{'0'}); % 记录被试编号

% 基本设置
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[xC, yC] = RectCenter(windowRect);

% 空矩阵及按键设置
training = nan(240,7);
test = nan(240,8);
zKey = KbName('z');
mKey = KbName('m');
escape = KbName('ESCAPE');

HideCursor; % 隐藏鼠标

%--------------------------------------------------------------------------

% 第一阶段指导语
Screen('TextSize', window, 30);
DrawFormattedText(window, double('欢迎参加本实验！\n\n在本阶段，你将会看到六个颜色不同的圆形，\n\n你的任务是找到红色或绿色的圆形（每个试次中只出现一种），\n\n如果该圆形内部的线段是垂直的，请用左手食指按键盘上的Z键；\n\n如果该圆形内部的线段是水平的，请用右手食指按键盘上的M键。\n\n每个正确反应之后，会得到一定的金钱奖励，\n\n表现越好，金钱奖励会越高，\n\n最后积累的钱数将作为最后的报酬。\n\n请在保证正确的前提下尽量快地做出反应。\n\n正式实验前会有30个试次的练习，练习阶段不会得到金钱奖励。\n\n如果准备好了，请按任意键继续。'), 'center', 'center', white)
Screen('Flip', window);
KbStrokeWait;

% 第一阶段练习试次
Screen('TextSize', window, 60);
DrawFormattedText(window, double('练习\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

color = repmat(['r','g'],1,15);
color = randsample(color,30);

for trial = 1:30;   
 
Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);
Screen('Flip', window);

WaitSecs(Sample([.4,.5,.6]));

Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);

rect = [xC-43.6,yC-177.4,xC+43.6,yC-87.2;xC-43.6,yC+87.2,xC+43.6,yC+177.4;xC-156.9,yC-112,xC-69.7,yC-21.8;...
       xC+69.7,yC-112,xC+156.9,yC-21.8;xC-156.9,yC+21.8,xC-69.7,yC+112;xC+69.7,yC+21.8,xC+156.9,yC+112];
col = [0,0,1;0,1,1;1,1,0;1,1,1;1,192/255,203/255;1,0.5,0];

id1=randperm(6);
rect1=rect(id1(1),:);

if color(trial) == 'g'
    Screen('FrameOval', window, [0 1 0], rect1',4);
else
    Screen('FrameOval', window, [1 0 0], rect1',4);
end
 
[x,y]=RectCenterd(rect1);
a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-30,y,x+30,y,4);
    else
Screen('DrawLine', window, white, x,y-30,x,y+30,4);
    end

rect(id1(1),:)=[];

id2=randperm(5);
rect2=rect(id2(1:5),:);
id3=randperm(6);
col1=col(id3(1:5),:);
Screen('FrameOval', window, col1', rect2',4);

[x1,y1] = RectCenterd(rect2(id2(1),:));
b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-22,y1-22,x1+22,y1+22,5);
    else
Screen('DrawLine', window, white, x1+22,y1-22,x1-22,y1+22,5); 
    end

[x2,y2] = RectCenterd(rect2(id2(2),:));
c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-22,y2-22,x2+22,y2+22,5);
    else
Screen('DrawLine', window, white, x2+22,y2-22,x2-22,y2+22,5); 
    end

[x3,y3] = RectCenterd(rect2(id2(3),:));
d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-22,y3-22,x3+22,y3+22,5);
    else
Screen('DrawLine', window, white, x3+22,y3-22,x3-22,y3+22,5); 
    end
    
[x4,y4] = RectCenterd(rect2(id2(4),:));
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-22,y4-22,x4+22,y4+22,5);
    else
Screen('DrawLine', window, white, x4+22,y4-22,x4-22,y4+22,5); 
    end
  
[x5,y5] = RectCenterd(rect2(id2(5),:));
f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-22,y5-22,x5+22,y5+22,4);
    else
Screen('DrawLine', window, white, x5+22,y5-22,x5-22,y5+22,4); 
    end

Screen('Flip', window);

tic;

respToBeMade = true;

 while respToBeMade == true; 
     
[KeyIsDown,secs,KeyCode] = KbCheck;

    if KeyCode(escape)
            sca;
    return 
    
    elseif KeyCode(mKey) && a > 0.5  && color(trial) == 'g'
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif KeyCode(mKey) && a > 0.5  && color(trial) == 'r'
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(zKey)  && a < 0.5  && color(trial) == 'g'
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(zKey)  && a < 0.5  && color(trial) == 'r'
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(mKey) && a < 0.5  || KeyCode(zKey)  && a > 0.5
        respToBeMade = false;
        Screen('Flip', window);
        WaitSecs(1.0);
        DrawFormattedText(window, double('错误'), 'center', 'center', white);
        Screen('Flip', window);
    WaitSecs(1.5);
       
      elseif toc >= 1.5
        respToBeMade = false;
        Screen('Flip', window);
        WaitSecs(1.0);
        DrawFormattedText(window,double('超时'), 'center', 'center', white);
        Screen('Flip', window);
    WaitSecs(1.5);
    
    end  
    
 end

    Screen('Flip', window);
    WaitSecs(1.0);  
 
end

DrawFormattedText(window, double('练习结束\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% 第一阶段正式试次
DrawFormattedText(window, double('第一阶段\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

A = repmat(['r','g'],1,30);
color1 = randsample(A,60);
color2 = randsample(A,60);
color3 = randsample(A,60);
color4 = randsample(A,60);
color = [color1,color2,color3,color4];

B = repmat(1:6,1,10);
position1 = randsample(B,60);
position2 = randsample(B,60);
position3 = randsample(B,60);
position4 = randsample(B,60);
position = [position1,position2,position3,position4];

points = repmat([0.15,0.15,0.15,0.15,0.03],1,12);
point1 = randsample(points,60);
while 1
    if sum(point1((color1=='g'))) == sum(point1((color1=='r')))
        break
    end
    point1 = randsample(points,60);
end  
point2 = randsample(points,60);
while 1
    if sum(point2((color2=='g'))) == sum(point2((color2=='r')))
        break
    end
    point2 = randsample(points,60);
end  
point3 = randsample(points,60);
while 1
    if sum(point3((color3=='g'))) == sum(point3((color3=='r')))
        break
    end
    point3 = randsample(points,60);
end  
point4 = randsample(points,60);
while 1
    if sum(point4((color4=='g'))) == sum(point4((color4=='r')))
        break
    end
    point4 = randsample(points,60);
end  
points = [point1,point2,point3,point4];

for trial = 1:240;
    
    if  trial ==1
        total = 0;
    end
    
    if  points(trial) == 0.15
        points_l = 0.03;
    elseif  points(trial) == 0.03
            points_l =0.15;
    end  

Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);
Screen('Flip', window);

WaitSecs(Sample([.4,.5,.6]));

Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);

rect = [xC-43.6,yC-177.4,xC+43.6,yC-87.2;xC-43.6,yC+87.2,xC+43.6,yC+177.4;xC-156.9,yC-112,xC-69.7,yC-21.8;...
       xC+69.7,yC-112,xC+156.9,yC-21.8;xC-156.9,yC+21.8,xC-69.7,yC+112;xC+69.7,yC+21.8,xC+156.9,yC+112];
col = [0,0,1;0,1,1;1,1,0;1,1,1;1,192/255,203/255;1,0.5,0];

id1=position(trial);
rect1=rect(id1(1),:);

if  color(trial) == 'g'
    Screen('FrameOval', window, [0 1 0], rect1',4);
else
    Screen('FrameOval', window, [1 0 0], rect1',4);
end
 
[x,y]=RectCenterd(rect1);
a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-30,y,x+30,y,4);
    else
Screen('DrawLine', window, white, x,y-30,x,y+30,4);
    end

rect(id1(1),:)=[];

id2=randperm(5);
rect2=rect(id2(1:5),:);
id3=randperm(6);
col1=col(id3(1:5),:);
Screen('FrameOval', window, col1', rect2',4);

[x1,y1] = RectCenterd(rect2(id2(1),:));
b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-22,y1-22,x1+22,y1+22,5);
    else
Screen('DrawLine', window, white, x1+22,y1-22,x1-22,y1+22,5); 
    end

[x2,y2] = RectCenterd(rect2(id2(2),:));
c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-22,y2-22,x2+22,y2+22,5);
    else
Screen('DrawLine', window, white, x2+22,y2-22,x2-22,y2+22,5); 
    end

[x3,y3] = RectCenterd(rect2(id2(3),:));
d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-22,y3-22,x3+22,y3+22,5);
    else
Screen('DrawLine', window, white, x3+22,y3-22,x3-22,y3+22,5); 
    end
    
[x4,y4] = RectCenterd(rect2(id2(4),:));
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-22,y4-22,x4+22,y4+22,5);
    else
Screen('DrawLine', window, white, x4+22,y4-22,x4-22,y4+22,5); 
    end
  
[x5,y5] = RectCenterd(rect2(id2(5),:));
f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-22,y5-22,x5+22,y5+22,4);
    else
Screen('DrawLine', window, white, x5+22,y5-22,x5-22,y5+22,4); 
    end

Screen('Flip', window);

tStart = GetSecs;
tic;

respToBeMade = true;

 while respToBeMade == true
     
[KeyIsDown,secs,KeyCode] = KbCheck;

    if KeyCode(escape)
            sca;
    return 
    
    elseif KeyCode(mKey) && a > 0.5  && color(trial) == 'g'
         response = 1;
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         total = total + points(trial);
         DrawFormattedText(window, [double('+') double([' ' num2str(points(trial)) ' ']) double('元') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif KeyCode(mKey) && a > 0.5  && color(trial) == 'r'
         response = 1;
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         total = total + points_l;
         DrawFormattedText(window, [double('+') double([' ' num2str(points_l) ' ']) double('元') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(zKey)  && a < 0.5  && color(trial) == 'g'
         response = 1;
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         total = total + points(trial);
         DrawFormattedText(window, [double('+') double([' ' num2str(points(trial)) ' ']) double('元') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(zKey)  && a < 0.5  && color(trial) == 'r'
         response = 1;
         respToBeMade = false;
         Screen('Flip', window);
         WaitSecs(1.0);
         total = total + points_l;
         DrawFormattedText(window, [double('+') double([' ' num2str(points_l) ' ']) double('元') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.5);
    
    elseif  KeyCode(mKey) && a < 0.5  || KeyCode(zKey)  && a > 0.5
        response = 0;
        respToBeMade = false;
        Screen('Flip', window);
        WaitSecs(1.0);
        DrawFormattedText(window, [double('错误') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
        Screen('Flip', window);
    WaitSecs(1.5);
       
    elseif  toc>1.5
        response = 0;
        respToBeMade = false;
        Screen('Flip', window);
        WaitSecs(1.0);
        DrawFormattedText(window, [double('超时') double(' \n\n ') double('共计')  double([' ' num2str(total) ' ']) double('元')], 'center', 'center', white);
        Screen('Flip', window);
    WaitSecs(1.5);
    
    end
 
 end

tEnd = GetSecs;
rt = tEnd - tStart-2.5; 
 
    training(trial,1) = trial;
    training(trial,2) = color(trial);
    training(trial,3) = rt;
    training(trial,4) = response;
    training(trial,5) = x;
    training(trial,6) = y;
    training(trial,7) = total;
    
    Screen('Flip', window);
    WaitSecs(1.0);  
    
if  trial == 60  ||  trial == 120  ||  trial == 180
    DrawFormattedText(window, double('休息一下\n\n按任意键继续'), 'center', 'center', white);
    Screen('Flip', window);
    KbStrokeWait;

end

end

DrawFormattedText(window, double('第一阶段结束\n\n请稍事休息\n\n按任意键进入下一阶段'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

%--------------------------------------------------------------------------

% 第二阶段指导语
Screen('TextSize', window, 30);
DrawFormattedText(window, double('在本阶段，你将会看到六个颜色不同的形状，\n\n或者是五个圆形一个菱形，或者是五个菱形一个圆形\n\n你的任务是找到那个不同的形状，\n\n如果该形状内部的线段是垂直的，请用左手食指按键盘上的Z键；\n\n如果该形状内部的线段是水平的，请用右手食指按键盘上的M键。\n\n本阶段不会得到金钱奖励，且无需关注颜色。\n\n请在保证正确的前提下尽量快地做出反应。\n\n正式实验前会有18个试次的练习。\n\n如果准备好了，请按任意键继续。'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% 第二阶段练习试次
Screen('TextSize', window, 60);
DrawFormattedText(window, double('练习\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

position = repmat(1:6,1,3);
position = randsample(position,18);

singleton = repmat(['c','d'],1,9);
singleton = randsample(singleton,18);

for trial = 1:18;
    
Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);
Screen('Flip', window);

WaitSecs(Sample([.4,.5,.6]));

Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);

rect = [xC-43.6,yC-177.4,xC+43.6,yC-87.2;xC-43.6,yC+87.2,xC+43.6,yC+177.4;xC-156.9,yC-112,xC-69.7,yC-21.8;...
       xC+69.7,yC-112,xC+156.9,yC-21.8;xC-156.9,yC+21.8,xC-69.7,yC+112;xC+69.7,yC+21.8,xC+156.9,yC+112];
col = [0,0,1;0,1,1;1,1,0;1,1,1;1,192/255,203/255;1,0.5,0];

id1=position(trial);
rect1=rect(id1(1),:);

if singleton(trial) == 'd'

id3=randperm(6);
col1=col(id3(1),:);       
        
[x,y]=RectCenterd(rect1);

point = [x,y+43.6;x-43.6,y;x,y-43.6;x+43.6,y];
Screen('FramePoly', window, col1,point,4);

a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-30,y,x+30,y,4);
    else
Screen('DrawLine', window, white, x,y-30,x,y+30,4);
    end

rect(id1(1),:)=[];
col(id3(1),:)=[];

id2=randperm(5);
id4=randperm(5);
rect2=rect(id2(1),:);
col2=col(id4(1),:);

Screen('FrameOval', window, col2', rect2',4);

[x1,y1] = RectCenterd(rect2);
b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-22,y1-22,x1+22,y1+22,5);
    else
Screen('DrawLine', window, white, x1+22,y1-22,x1-22,y1+22,5); 
    end

rect(id2(1),:)=[];
col(id4(1),:)=[]; 
    
id5=randperm(4);
id6=randperm(4);
rect3=rect(id5(1:4),:);
col3=col(id6(1:4),:);

Screen('FrameOval', window, col3', rect3',4);
    
[x2,y2] = RectCenterd(rect3(id5(1),:));
c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-22,y2-22,x2+22,y2+22,5);
    else
Screen('DrawLine', window, white, x2+22,y2-22,x2-22,y2+22,5); 
    end

[x3,y3] = RectCenterd(rect3(id5(2),:));
d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-22,y3-22,x3+22,y3+22,5);
    else
Screen('DrawLine', window, white, x3+22,y3-22,x3-22,y3+22,5); 
    end
    
[x4,y4] = RectCenterd(rect3(id5(3),:));
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-22,y4-22,x4+22,y4+22,5);
    else
Screen('DrawLine', window, white, x4+22,y4-22,x4-22,y4+22,5); 
    end
  
[x5,y5] = RectCenterd(rect3(id5(4),:));
f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-22,y5-22,x5+22,y5+22,5);
    else
Screen('DrawLine', window, white, x5+22,y5-22,x5-22,y5+22,5); 
    end

Screen('Flip', window);

elseif singleton(trial) == 'c'
        
id3=randperm(6);
col1=col(id3(1),:);       
        
[x,y]=RectCenterd(rect1);

Screen('FrameOval', window, col1,rect1',4);

a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-32,y,x+32,y,4);
    else
Screen('DrawLine', window, white, x,y-32,x,y+32,4);
    end

rect(id1(1),:)=[];
col(id3(1),:)=[];

id2=randperm(5);
id4=randperm(5);
rect2=rect(id2(1),:);
col2=col(id4(1),:);

[x1,y1] = RectCenterd(rect2);
diamond1 = [x1,y1+43.6;x1-43.6,y1;x1,y1-43.6;x1+43.6,y1];
Screen('FramePoly', window, col2', diamond1,4);
 
b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-17,y1-17,x1+17,y1+17,5);
    else
Screen('DrawLine', window, white, x1+17,y1-17,x1-17,y1+17,5); 
    end

rect(id2(1),:)=[];
col(id4(1),:)=[]; 
    
id5=randperm(4);
id6=randperm(4);
rect3=rect(id5(1:4),:);
col3=col(id6(1),:);
col4=col(id6(2),:);
col5=col(id6(3),:);
col6=col(id6(4),:);

[x2,y2] = RectCenterd(rect3(id5(1),:));
diamond2 = [x2,y2+43.6;x2-43.6,y2;x2,y2-43.6;x2+43.6,y2];
[x3,y3] = RectCenterd(rect3(id5(2),:));
diamond3 = [x3,y3+43.6;x3-43.6,y3;x3,y3-43.6;x3+43.6,y3];
[x4,y4] = RectCenterd(rect3(id5(3),:));
diamond4 = [x4,y4+43.6;x4-43.6,y4;x4,y4-43.6;x4+43.6,y4];
[x5,y5] = RectCenterd(rect3(id5(4),:));
diamond5 = [x5,y5+43.6;x5-43.6,y5;x5,y5-43.6;x5+43.6,y5];
Screen('FramePoly', window, col3', diamond2,4);
Screen('FramePoly', window, col4', diamond3,4);
Screen('FramePoly', window, col5', diamond4,4);
Screen('FramePoly', window, col6', diamond5,4);

c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-17,y2-17,x2+17,y2+17,5);
    else
Screen('DrawLine', window, white, x2+17,y2-17,x2-17,y2+17,5); 
    end

d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-17,y3-17,x3+17,y3+17,5);
    else
Screen('DrawLine', window, white, x3+17,y3-17,x3-17,y3+17,5); 
    end
    
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-17,y4-17,x4+17,y4+17,5);
    else
Screen('DrawLine', window, white, x4+17,y4-17,x4-17,y4+17,5); 
    end

f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-17,y5-17,x5+17,y5+17,5);
    else
Screen('DrawLine', window, white, x5+17,y5-17,x5-17,y5+17,5); 
    end

Screen('Flip', window);        
    
end

tic;

respToBeMade = true;

 while respToBeMade == true
     
[KeyIsDown,secs,KeyCode] = KbCheck;

    if KeyCode(escape)
       sca;
    return
    
    elseif KeyCode(mKey) && a > 0.5  ||  KeyCode(zKey)  && a < 0.5 
         respToBeMade = false;
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);
    
    elseif KeyCode(zKey) && a > 0.5  ||  KeyCode(mKey)  && a < 0.5
         respToBeMade = false;
         DrawFormattedText(window, double('错误'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);
    
    elseif toc>1.5
         respToBeMade = false;
         DrawFormattedText(window, double('超时'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);
    
    end  
    
 end

    Screen('Flip', window);
    WaitSecs(0.5);  
 
end
    
DrawFormattedText(window, double('练习结束\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% 第二阶段正式试次
DrawFormattedText(window, double('第二阶段\n\n按任意键继续'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

D = repmat(['r','g','o','o'],1,15);
color_test1 = randsample(D,60);
color_test2 = randsample(D,60);
color_test3 = randsample(D,60);
color_test4 = randsample(D,60);
color_test = [color_test1,color_test2,color_test3,color_test4];

shape = repmat(['c','d'],1,30);
singleton1 = randsample(shape,60);
singleton2 = randsample(shape,60);
singleton3 = randsample(shape,60);
singleton4 = randsample(shape,60);
singleton = [singleton1,singleton2,singleton3,singleton4];

E = repmat(1:6,1,10);
p_o1 = randsample(E,60);
p_d1 = randsample(E,60);
while 1
    if p_o1(1:60)~=p_d1(1:60)
        break
    end
    p_d1 = randsample(E,60);
end   
p_o2 = randsample(E,60);
p_d2 = randsample(E,60);
while 1
    if p_o2(1:60)~=p_d2(1:60)
        break
    end
    p_d2 = randsample(E,60);
end  
p_o3 = randsample(E,60);
p_d3 = randsample(E,60);
while 1
    if p_o3(1:60)~=p_d3(1:60)
        break
    end
    p_d3 = randsample(E,60);
end  
p_o4 = randsample(E,60);
p_d4 = randsample(E,60);
while 1
    if p_o4(1:60)~=p_d4(1:60)
        break
    end
    p_d4 = randsample(E,60);
end  
position_o = [p_o1,p_o2,p_o3,p_o4];
position_d = [p_d1,p_d2,p_d3,p_d4];

for trial = 1:240;
    
Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);
Screen('Flip', window);

WaitSecs(Sample([.4,.5,.6]));

Screen('DrawLines', window, [-8.72 8.72 0 0; 0 0 -8.72 8.72],3, white, [xC yC],2);

rect = [xC-43.6,yC-177.4,xC+43.6,yC-87.2;xC-43.6,yC+87.2,xC+43.6,yC+177.4;xC-156.9,yC-112,xC-69.7,yC-21.8;...
       xC+69.7,yC-112,xC+156.9,yC-21.8;xC-156.9,yC+21.8,xC-69.7,yC+112;xC+69.7,yC+21.8,xC+156.9,yC+112];
col = [0,0,1;0,1,1;1,1,0;1,1,1;1,192/255,203/255;1,0.5,0];

id1=position_o(trial);
rect1=rect(id1(1),:);
id2=position_d(trial);
rect2=rect(id2(1),:);

if singleton(trial) == 'd'

id3=randperm(6);
col1=col(id3(1),:);
        
[x,y]=RectCenterd(rect1);

point = [x,y+43.6;x-43.6,y;x,y-43.6;x+43.6,y];
Screen('FramePoly', window, col1,point,4);

a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-30,y,x+30,y,4);
    else
Screen('DrawLine', window, white, x,y-30,x,y+30,4);
    end

rect([id1(1),id2(1)],:)=[];
col(id3(1),:)=[];

id4=randperm(5);
col2=col(id4(1),:);

    if color_test(trial) == 'g'
Screen('FrameOval', window, [0 1 0], rect2',4);
    elseif color_test(trial) == 'r'
Screen('FrameOval', window, [1 0 0], rect2',4);  
    else
Screen('FrameOval', window, col2', rect2',4);
    end

[x1,y1] = RectCenterd(rect2);
b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-22,y1-22,x1+22,y1+22,5);
    else
Screen('DrawLine', window, white, x1+22,y1-22,x1-22,y1+22,5); 
    end

col(id4(1),:)=[]; 
    
id5=randperm(4);
id6=randperm(4);
rect3=rect(id5(1:4),:);
col3=col(id6(1:4),:);

Screen('FrameOval', window, col3', rect3',4);
    
[x2,y2] = RectCenterd(rect3(id5(1),:));
c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-22,y2-22,x2+22,y2+22,5);
    else
Screen('DrawLine', window, white, x2+22,y2-22,x2-22,y2+22,5); 
    end

[x3,y3] = RectCenterd(rect3(id5(2),:));
d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-22,y3-22,x3+22,y3+22,5);
    else
Screen('DrawLine', window, white, x3+22,y3-22,x3-22,y3+22,5); 
    end
    
[x4,y4] = RectCenterd(rect3(id5(3),:));
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-22,y4-22,x4+22,y4+22,5);
    else
Screen('DrawLine', window, white, x4+22,y4-22,x4-22,y4+22,5); 
    end
  
[x5,y5] = RectCenterd(rect3(id5(4),:));
f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-22,y5-22,x5+22,y5+22,5);
    else
Screen('DrawLine', window, white, x5+22,y5-22,x5-22,y5+22,5); 
    end

Screen('Flip', window);

elseif singleton(trial) == 'c'
        
id3=randperm(6);
col1=col(id3(1),:);       
        
[x,y]=RectCenterd(rect1);

Screen('FrameOval', window, col1,rect1',4);

a=rand(1);
    if a >0.5
Screen('DrawLine', window, white, x-32,y,x+32,y,4);
    else
Screen('DrawLine', window, white, x,y-32,x,y+32,4);
    end

rect([id1(1),id2(1)],:)=[];
col(id3(1),:)=[];

id4=randperm(5);
col2=col(id4(1),:);

[x1,y1] = RectCenterd(rect2);
diamond1 = [x1,y1+43.6;x1-43.6,y1;x1,y1-43.6;x1+43.6,y1];

    if color_test(trial) == 'g'
Screen('FramePoly', window, [0 1 0], diamond1,4);
    elseif color_test(trial) == 'r'
Screen('FramePoly', window, [1 0 0], diamond1,4);  
    else
Screen('FramePoly', window, col2', diamond1,4);
    end

b=rand(1);
    if b>0.5
Screen('DrawLine', window, white, x1-17,y1-17,x1+17,y1+17,5);
    else
Screen('DrawLine', window, white, x1+17,y1-17,x1-17,y1+17,5); 
    end

col(id4(1),:)=[]; 
    
id5=randperm(4);
id6=randperm(4);
rect3=rect(id5(1:4),:);
col3=col(id6(1),:);
col4=col(id6(2),:);
col5=col(id6(3),:);
col6=col(id6(4),:);

[x2,y2] = RectCenterd(rect3(id5(1),:));
diamond2 = [x2,y2+43.6;x2-43.6,y2;x2,y2-43.6;x2+43.6,y2];
[x3,y3] = RectCenterd(rect3(id5(2),:));
diamond3 = [x3,y3+43.6;x3-43.6,y3;x3,y3-43.6;x3+43.6,y3];
[x4,y4] = RectCenterd(rect3(id5(3),:));
diamond4 = [x4,y4+43.6;x4-43.6,y4;x4,y4-43.6;x4+43.6,y4];
[x5,y5] = RectCenterd(rect3(id5(4),:));
diamond5 = [x5,y5+43.6;x5-43.6,y5;x5,y5-43.6;x5+43.6,y5];
Screen('FramePoly', window, col3', diamond2,4);
Screen('FramePoly', window, col4', diamond3,4);
Screen('FramePoly', window, col5', diamond4,4);
Screen('FramePoly', window, col6', diamond5,4);

c=rand(1);
    if c>0.5
Screen('DrawLine', window, white, x2-17,y2-17,x2+17,y2+17,5);
    else
Screen('DrawLine', window, white, x2+17,y2-17,x2-17,y2+17,5); 
    end

d=rand(1);
    if d>0.5
Screen('DrawLine', window, white, x3-17,y3-17,x3+17,y3+17,5);
    else
Screen('DrawLine', window, white, x3+17,y3-17,x3-17,y3+17,5); 
    end
    
e=rand(1);
    if e>0.5
Screen('DrawLine', window, white, x4-17,y4-17,x4+17,y4+17,5);
    else
Screen('DrawLine', window, white, x4+17,y4-17,x4-17,y4+17,5); 
    end

f=rand(1);
    if f>0.5
Screen('DrawLine', window, white, x5-17,y5-17,x5+17,y5+17,5);
    else
Screen('DrawLine', window, white, x5+17,y5-17,x5-17,y5+17,5); 
    end

Screen('Flip', window);        
           
end

tStart = GetSecs;
tic;

respToBeMade = true;

 while respToBeMade == true
     
[KeyIsDown,secs,KeyCode] = KbCheck;

    if KeyCode(escape)
            sca;
    return 
    
    elseif KeyCode(mKey) && a > 0.5  &&  color_test(trial) == 'g'  ||  KeyCode(zKey)  && a < 0.5  && color_test(trial) == 'g'
         response = 1;
         respToBeMade = false;
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);
    
    elseif KeyCode(mKey) && a > 0.5  &&  color_test(trial) == 'r'  ||  KeyCode(zKey)  && a < 0.5  && color_test(trial) == 'r'
         response = 1;
         respToBeMade = false;
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);
        
    elseif  KeyCode(mKey) && a > 0.5  && color_test(trial) == 'o'  ||  KeyCode(zKey)  && a < 0.5  && color_test(trial) == 'o'
         response = 1;
         respToBeMade = false;
         DrawFormattedText(window, double('正确'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);     
    
    elseif KeyCode(zKey) && a > 0.5  ||  KeyCode(mKey)  && a < 0.5
         response = 0;
         respToBeMade = false;
         DrawFormattedText(window, double('错误'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);    
    
    elseif toc>1.5
         response = 0;
         respToBeMade = false;
         DrawFormattedText(window, double('超时'), 'center', 'center', white);
         Screen('Flip', window);
    WaitSecs(1.0);    
    
    end  
    
 end

tEnd = GetSecs;
rt = tEnd - tStart-1.0;

    test(trial,1) = color_test(trial);
    test(trial,2) = singleton(trial);
    test(trial,3) = rt;
    test(trial,4) = response;
    test(trial,5) = x;
    test(trial,6) = y;
    test(trial,7) = x1;
    test(trial,8) = y1;
 
    Screen('Flip', window);
    WaitSecs(0.5);  
 
if  trial == 60   ||  trial == 120  ||  trial == 180
    DrawFormattedText(window, double('休息一下\n\n按任意键继续'), 'center', 'center', white);
    
    Screen('Flip', window);
    KbStrokeWait;
end 

end

DrawFormattedText(window, double('全部实验结束\n\n谢谢！'), 'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;

% 记录数据
results = [training,test]; 
csvwrite(['sub_money2_g' char(answer(1)) '.csv'],results,0);

ShowCursor; % 显示鼠标

sca; % 退出