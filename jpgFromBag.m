    clc;
    [fileBag,percorsoFile] = uigetfile('*.bag');
    if isequal(fileBag,0)
        disp('Annullato');
    else
        disp(['File selezionato: ', fullfile(percorsoFile,fileBag)]);
    end
    bag = rosbag(fileBag) % Load the rosbag.
    
    %per visualizzare informazioni disponibili sul file bag
    %eseguire in command window dopo istruzione #8
    %rosbag info '<fileBag>'
   
    % nel terzo parametro inserire
    % /camera/aligned_depth_to_color/image_raw 
    %oppure
    % /camera/color/image_raw                   
    %oppure
    % /camera/color/image_rect_color
    bSel = select(bag, 'Topic', '/camera/color/image_rect_color');
    
    % Read all the messages (here, frames) in that topic as an nx1 cell array.
    msgs = readMessages(bSel); 

    frameBag = numel(msgs);
    prompt = ['ogni quanti frame del video catturarne uno, (max ',num2str(frameBag),'): '];
    
    intero = 0;
    campionamento = 0;
    %non accetta numero di frame <0 o >#frame disponibili
    %non accetta valori non numerici, arrotonda reali
    while(intero~=1 || campionamento<1 || campionamento>frameBag)
        campionamento = input(prompt);
        intero = isnumeric(campionamento);
    end   
    
    cartellaAttuale = pwd;
    selpath = uigetdir(cartellaAttuale);
    
    indiceImmagine = 0;
    % Iterate sull'array e legge ogni frame con passo=campionamento
    for i = 1 : campionamento: numel(msgs)
        %per disaccoppiare #frame da #immagine nel nome del file salvato
        %eliminare commento da 44
        %indiceImmagine = indiceImmagine +1;
        [img,alpha] = readImage(msgs{i}); %opens image i
        %imshow(img)
        %estrae parti del nome file
        [percorso,nome,estensione] = fileparts(fileBag);
        %disaccoppia #frame da #immagine salvata
        indice = int2str(i);
        nomeImmagine = strcat(nome,indice);
        %gcf is the handle for the current figure
        %saveas(gcf,fullfile(selpath, nomeImmagine),'jpg');

        nomeFile = sprintf('%s%d.jpg',nome,i)
        fname=fullfile(selpath,nomeFile)
        imwrite(img, fname, 'jpg')
    end
