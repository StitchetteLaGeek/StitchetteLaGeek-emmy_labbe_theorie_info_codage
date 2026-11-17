function LANCER_TP_COMPLET
%% ================================================================
%  THEORIE DE L'INFORMATION ET DU CODAGE
%  TP MATLAB / SIMULINK
%
%  Labbé Emmy
%  ENSIM - 5A ASTRE
%
%  Lanceur principal du TP
%
%  A lancer simplement avec :
%
%       LANCER_TP_COMPLET
%
%% ================================================================

clc;

%% ================================================================
% CONFIGURATION
%% ================================================================

SAUVER_FIGURES = true;
SIMULER_MODELES = true;

%% ================================================================
% DOSSIER DU TP
%% ================================================================

DOSSIER_TP = fileparts(mfilename('fullpath'));

if isempty(DOSSIER_TP)
    DOSSIER_TP = pwd;
end

% Ajout du dossier + sous-dossiers au path MATLAB
addpath(genpath(DOSSIER_TP));

% dossier de résultats
DOSSIER_RESULTATS = fullfile(DOSSIER_TP, 'RESULTATS_TP');

if ~exist(DOSSIER_RESULTATS, 'dir')
    mkdir(DOSSIER_RESULTATS);
end

%% ================================================================
% BOUCLE PRINCIPALE
%% ================================================================

while true

    clc;

    afficher_entete();

    fprintf('MENU PRINCIPAL\n');
    fprintf('============================================================\n\n');

    fprintf('  1  - Lancer le TP complet\n');
    fprintf('  2  - Partie 2 : Codage de source\n');
    fprintf('  3  - Partie 3 : Chaine de transmission\n');
    fprintf('  4  - Partie 4 : Hamming (7,4)\n');
    fprintf('  5  - Partie 5 : QPSK\n');
    fprintf('  6  - Partie 6 : Filtrage / RRC\n');
    fprintf('  7  - Partie 7 : Canal a deux trajets\n');
    fprintf('\n');
    fprintf('  F  - Ouvrir les figures sauvegardees\n');
    fprintf('  D  - Ouvrir le dossier RESULTATS_TP\n');
    fprintf('  Q  - Quitter\n\n');

    choix = lower(strtrim(input('Votre choix : ', 's')));

    switch choix

        case '1'

            action = lancer_plusieurs_parties( ...
                2:7, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '2'

            action = lancer_partie( ...
                2, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '3'

            action = lancer_partie( ...
                3, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '4'

            action = lancer_partie( ...
                4, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '5'

            action = lancer_partie( ...
                5, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '6'

            action = lancer_partie( ...
                6, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case '7'

            action = lancer_partie( ...
                7, ...
                DOSSIER_TP, ...
                DOSSIER_RESULTATS, ...
                SAUVER_FIGURES, ...
                SIMULER_MODELES);

            if strcmp(action, 'quit')
                afficher_sortie(DOSSIER_RESULTATS);
                return;
            end

        case 'f'

            ouvrir_figures(DOSSIER_RESULTATS);

        case 'd'

            ouvrir_dossier(DOSSIER_RESULTATS);

        case {'q','quit','quitter','exit'}

            afficher_sortie(DOSSIER_RESULTATS);
            return;

        otherwise

            fprintf('\nChoix non reconnu.\n');
            pause(1);

    end

end

end


%% =================================================================
%% LANCER PLUSIEURS PARTIES
%% =================================================================

function action = lancer_plusieurs_parties( ...
    parties, ...
    dossier_TP, ...
    dossier_resultats, ...
    sauver_figures, ...
    simuler_modeles)

action = 'continue';

for numero = parties

    action = lancer_partie( ...
        numero, ...
        dossier_TP, ...
        dossier_resultats, ...
        sauver_figures, ...
        simuler_modeles);

    if strcmp(action, 'quit') || strcmp(action, 'menu')
        return;
    end

end

fprintf('\n\n');
fprintf('############################################################\n');
fprintf('#                                                          #\n');
fprintf('#                     FIN DU TP                            #\n');
fprintf('#                                                          #\n');
fprintf('############################################################\n\n');

fprintf('Toutes les parties ont ete parcourues.\n\n');

fprintf('Les resultats sont sauvegardes dans :\n');
fprintf('%s\n\n', dossier_resultats);

action = choix_etape('Fin du TP - ENTREE = menu principal | Q = quitter');

end


%% =================================================================
%% LANCER UNE PARTIE
%% =================================================================

function action = lancer_partie( ...
    numero, ...
    dossier_TP, ...
    dossier_resultats, ...
    sauver_figures, ...
    simuler_modeles)

action = 'continue';

cfg = configuration_partie(numero);

clc;

fprintf('\n');
fprintf('############################################################\n');
fprintf('#                                                          #\n');
fprintf('#   PARTIE %d - %s\n', numero, cfg.titre);
fprintf('#                                                          #\n');
fprintf('############################################################\n\n');

fprintf('Nombre d''etapes : %d\n\n', length(cfg.etapes));

depart = choix_etape( ...
    'ENTREE = commencer | M = menu principal | Q = quitter');

if strcmp(depart, 'quit')
    action = 'quit';
    return;
elseif strcmp(depart, 'menu')
    action = 'menu';
    return;
end

%% ================================================================
% BOUCLE SUR LES ETAPES
%% ================================================================

i = 1;

while i <= length(cfg.etapes)

    etape = cfg.etapes(i);

    if strcmp(etape.type, 'script')

        action_etape = executer_script_etape( ...
            etape, ...
            dossier_TP, ...
            dossier_resultats, ...
            sauver_figures);

    elseif strcmp(etape.type, 'simulink')

        action_etape = executer_simulink_etape( ...
            etape, ...
            dossier_TP, ...
            simuler_modeles);

    elseif strcmp(etape.type, 'texte')

        action_etape = afficher_etape_theorique(etape);

    else

        action_etape = 'next';

    end

    %% ------------------------------------------------------------
    % ACTION
    %% ------------------------------------------------------------

    switch action_etape

        case 'rerun'

            % Ne change pas i
            continue;

        case 'quit'

            action = 'quit';
            return;

        case 'menu'

            action = 'menu';
            return;

        otherwise

            i = i + 1;

    end

end

%% ================================================================
% FIN DE PARTIE
%% ================================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('FIN DE LA PARTIE %d\n', numero);
fprintf('============================================================\n\n');

rep = choix_etape( ...
    'ENTREE = continuer | M = menu principal | Q = quitter');

if strcmp(rep, 'quit')
    action = 'quit';
elseif strcmp(rep, 'menu')
    action = 'menu';
else
    action = 'continue';
end

end


%% =================================================================
%% CONFIGURATION DES PARTIES
%% =================================================================

function cfg = configuration_partie(numero)

cfg.titre = '';
cfg.etapes = struct( ...
    'type', {}, ...
    'titre', {}, ...
    'fichiers', {}, ...
    'commande', {}, ...
    'texte', {});

switch numero

%% =================================================================
% PARTIE 2
%% =================================================================

case 2

    cfg.titre = 'CODAGE DE SOURCE';

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q1 : Generation de la source binaire', ...
        {'P2_Q1_source_binaire_simulation.m'});

    cfg.etapes(end+1) = commande_etape( ...
        'P2 - Q2 : Entropie empirique', ...
        {'entropie_empirique.m'}, ...
        ['H_empirique = entropie_empirique(bits); ' ...
         'fprintf(''Entropie empirique = %.4f bits/symbole\n'', H_empirique);']);

    cfg.etapes(end+1) = simulink_etape( ...
        'P2 - Q1/Q2 : Source binaire Simulink', ...
        {'source_binaire.slx'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q3 : Entropie d''un texte', ...
        {'P2_Q3_entropie_texte.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q4 : Codage de Huffman par blocs', ...
        {'P2_Q4_huffman_blocs.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q5 : Huffman applique au texte', ...
        {'P2_Q5_huffman_texte.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q6 : Cout de la table Huffman', ...
        {'P2_Q6_cout_table_huffman.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q7 : Extension de la source', ...
        {'P2_Q7_extension_source.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q8 : Memoire de la source', ...
        {'P2_Q8_memoire_source.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q9 : Sortie Huffman', ...
        {'P2_Q9_sortie_huffman.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q10 : LZ78', ...
        {'P2_Q10_LZ78.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P2 - Q11 : Convergence de LZ78', ...
        {'P2_Q11_LZ78_convergence.m'});


%% =================================================================
% PARTIE 3
%% =================================================================

case 3

    cfg.titre = 'CHAINE DE TRANSMISSION DE BASE';

    % P3_Q1_canal_CBS.m = fonction utilitaire
    % donc on commence avec le script de simulation Q2.

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q2 : Simulation du canal binaire symetrique', ...
        {'P3_Q2_simulation_CBS.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q3 : Capacite du canal binaire symetrique', ...
        {'P3_Q3_capacite_CBS.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q4 : Bruit uniforme', ...
        {'P3_Q4_bruit_uniforme.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q5 : Probabilite d''erreur uniforme', ...
        {'P3_Q5_erreur_uniforme.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q6 : Simulation du canal uniforme', ...
        {'P3_Q6_simulation_uniforme.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q7 : Canal gaussien', ...
        {'P3_Q7_canal_gaussien.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q8 : Simulation du canal gaussien', ...
        {'P3_Q8_simulation_gaussien.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q9 : Comparaison des canaux', ...
        {'P3_Q9_comparaison_canaux.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q10 : Parametres de l''integration', ...
        {'P3_Q10_parametres_integration.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q11 : Variance de l''integrateur', ...
        { ...
        'P3_Q11_variance_integrateur.m', ...
        'question11_variance_integrateur.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q12 : TEB', ...
        { ...
        'P3_Q12_TEB.m', ...
        'question12_TEB.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P3 - Q13 : Integration et detection', ...
        { ...
        'P3_Q13_integration.m', ...
        'question13_bruit_uniforme_integration.m' ...
        });

    cfg.etapes(end+1) = simulink_etape( ...
        'P3 - Modele Simulink de la chaine de base', ...
        {'chaine_base.slx'});


%% =================================================================
% PARTIE 4
%% =================================================================

case 4

    cfg.titre = 'CODAGE DE CANAL HAMMING (7,4)';

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q1 : Introduction au code Hamming', ...
        { ...
        'P4_Q1_hamming_definition.m', ...
        'question1_hamming.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q2 : Matrices G et H', ...
        { ...
        'P4_Q2_hamming_matrices.m', ...
        'question2_hamming.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q3 : Distance minimale', ...
        { ...
        'P4_Q3_hamming_distance.m', ...
        'question3_hamming.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q4/Q5 : Codeur par registre', ...
        { ...
        'P4_Q4_Q5_hamming_registre.m', ...
        'question4_5_registre_hamming.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q7 : Verification matricielle', ...
        {'P4_Q7_hamming_matrice.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q8 : Correction d''une erreur', ...
        {'P4_Q8_hamming_correction.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q9 : Verification du codeur', ...
        {'P4_Q9_hamming_codeur.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q10 : Probabilite d''erreur', ...
        {'P4_Q10_hamming_probabilite.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P4 - Q11 : Gain de codage', ...
        {'P4_Q11_hamming_gain.m'});

    cfg.etapes(end+1) = simulink_etape( ...
        'P4 - Modele Simulink avec Hamming', ...
        {'chaine_hamming.slx'});


%% =================================================================
% PARTIE 5
%% =================================================================

case 5

    cfg.titre = 'MODULATION QPSK';

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q1 : Constellation QPSK Gray', ...
        { ...
        'P5_Q1_constellation_QPSK.m', ...
        'question1_qpsk.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q2 : Modulation / demodulation', ...
        { ...
        'P5_Q2_modulation_demodulation_QPSK.m', ...
        'question2_qpsk.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q3 : QPSK avec bruit', ...
        { ...
        'P5_Q3_QPSK_bruit.m', ...
        'question3_qpsk.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q4 : TEB QPSK / binaire', ...
        { ...
        'P5_Q4_TEB_QPSK.m', ...
        'question4_qpsk.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q5 : Mapping Gray / naturel', ...
        { ...
        'P5_Q5_QPSK_gray_naturel.m', ...
        'question5_qpsk.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P5 - Q6 : QPSK + Hamming', ...
        { ...
        'P5_Q6_QPSK_hamming.m', ...
        'question6_qpsk.m' ...
        });


%% =================================================================
% PARTIE 6
%% =================================================================

case 6

    cfg.titre = 'FILTRAGE ET MISE EN FORME';

    cfg.etapes(end+1) = script_etape( ...
        'P6 - Q1 : Filtre porte', ...
        { ...
        'P6_Q1_filtre_porte.m', ...
        'question1_partie6.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P6 - Q2/Q3 : Filtre RRC et reponse globale', ...
        { ...
        'P6_Q2_filtre_adapte.m', ...
        'question2_partie6.m' ...
        });

    cfg.etapes(end+1) = script_etape( ...
        'P6 - Q4 : DSP porte / RRC', ...
        {'P6_Q4_DSP_porte_RRC.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P6 - Q5 : QPSK + RRC + diagramme de l''oeil', ...
        {'P6_Q5_QPSK_RRC_oeil.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P6 - Q6 : Decalage de T/4', ...
        {'P6_Q6_decalage_echantillonnage.m'});


%% =================================================================
% PARTIE 7
%% =================================================================

case 7

    cfg.titre = 'CANAL A DEUX TRAJETS';

    cfg.etapes(end+1) = script_etape( ...
        'P7 - Q1 : Canal a deux trajets', ...
        {'P7_Q1_canal_deux_trajets.m'});

    cfg.etapes(end+1) = texte_etape( ...
        'P7 - Q2 : Egalisation du canal', ...
        sprintf([ ...
        'Le canal a deux trajets introduit de l''IES.\n\n' ...
        'Une solution consiste a ajouter un egaliseur au recepteur.\n' ...
        'Il faut connaitre ou estimer :\n' ...
        '  - beta, amplitude de l''echo ;\n' ...
        '  - tau, retard de l''echo ;\n' ...
        '  - la reponse impulsionnelle du canal.\n' ...
        ]));

    cfg.etapes(end+1) = script_etape( ...
        'P7 - Q3 : Transmission du texte sans Hamming', ...
        {'P7_Q3_texte_sans_hamming.m'});

    cfg.etapes(end+1) = script_etape( ...
        'P7 - Q3 : Transmission du texte avec Hamming', ...
        {'P7_Q3_texte_avec_hamming.m'});

end

end


%% =================================================================
%% CONSTRUCTION D'UNE ETAPE SCRIPT
%% =================================================================

function e = script_etape(titre, fichiers)

e.type = 'script';
e.titre = titre;
e.fichiers = fichiers;
e.commande = '';
e.texte = '';

end


%% =================================================================
%% CONSTRUCTION D'UNE ETAPE SIMULINK
%% =================================================================

function e = commande_etape(titre, fichiers, commande)

% Appel d'une fonction avec ses arguments, sans modifier son code.
e = script_etape(titre, fichiers);
e.commande = commande;

end


function e = simulink_etape(titre, fichiers)

e.type = 'simulink';
e.titre = titre;
e.fichiers = fichiers;
e.commande = '';
e.texte = '';

end


%% =================================================================
%% CONSTRUCTION D'UNE ETAPE TEXTE
%% =================================================================

function e = texte_etape(titre, texte)

e.type = 'texte';
e.titre = titre;
e.fichiers = {};
e.commande = '';
e.texte = texte;

end


%% =================================================================
%% EXECUTION D'UN SCRIPT
%% =================================================================

function action = executer_script_etape( ...
    etape, ...
    dossier_TP, ...
    dossier_resultats, ...
    sauver_figures)

action = 'next';

while true

    fprintf('\n\n');
    fprintf('============================================================\n');
    fprintf('%s\n', etape.titre);
    fprintf('============================================================\n\n');

    %% ------------------------------------------------------------
    % RECHERCHE DU SCRIPT
    %% ------------------------------------------------------------

    fichier = chercher_fichier( ...
        etape.fichiers, ...
        dossier_TP);

    if isempty(fichier)

        fprintf('[FICHIER NON TROUVE]\n\n');

        fprintf('Fichiers recherches :\n');

        for k = 1:length(etape.fichiers)

            fprintf('  - %s\n', etape.fichiers{k});

        end

        fprintf('\n');

        choix = choix_etape( ...
            'ENTREE = suivante | R = rechercher a nouveau | M = menu | Q = quitter');

        if strcmp(choix, 'rerun')
            continue;
        else
            action = choix;
            return;
        end

    end

    fprintf('Script : %s\n\n', fichier);

    if contains(fichier, 'P2_Q11_LZ78_convergence.m')
        fprintf(['Calcul LZ78 sur un million de bits : cette etape peut ' ...
                 'prendre plusieurs minutes.\nPatientez jusqu''au retour du choix suivant.\n\n']);
        drawnow;
    end

    %% ------------------------------------------------------------
    % DOSSIER DU SCRIPT
    %% ------------------------------------------------------------

    dossier_script = fileparts(fichier);
    ancien_dossier = pwd;

    %% ------------------------------------------------------------
    % FIGURES AVANT EXECUTION
    %% ------------------------------------------------------------

    figures_avant = findall(0, 'Type', 'figure');

    %% ------------------------------------------------------------
    % EXECUTION
    %% ------------------------------------------------------------

    sortie = '';
    erreur = '';
    execution_ok = true;

    try

        cd(dossier_script);

        fichier_echappe = strrep( ...
            fichier, ...
            '''', ...
            '''''');

        commande = sprintf( ...
            'run(''%s'');', ...
            fichier_echappe);

        if ~isempty(etape.commande)
            commande = etape.commande;
        end

        %% Exécution dans le Workspace principal
        % Ainsi les variables restent visibles pour le professeur.

        sortie = evalc( ...
            'evalin(''base'', commande);');

        cd(ancien_dossier);

    catch ME

        cd(ancien_dossier);

        execution_ok = false;
        erreur = ME.message;

    end

    %% ------------------------------------------------------------
    % AFFICHAGE
    %% ------------------------------------------------------------

    fprintf('------------------------------------------------------------\n');
    fprintf('RESULTATS\n');
    fprintf('------------------------------------------------------------\n\n');

    if ~isempty(sortie)
        fprintf('%s', sortie);
    end

    if execution_ok

        fprintf('\n[OK] Execution terminee.\n');

    else

        fprintf('\n[ERREUR DANS LE SCRIPT]\n');
        fprintf('%s\n', erreur);

    end

    drawnow;

    %% ------------------------------------------------------------
    % FIGURES APRES EXECUTION
    %% ------------------------------------------------------------

    figures_apres = findall(0, 'Type', 'figure');

    nouvelles_figures = setdiff( ...
        figures_apres, ...
        figures_avant);

    %% Si le script a fait close all puis créé de nouvelles figures
    if isempty(nouvelles_figures) && ~isempty(figures_apres)
        nouvelles_figures = figures_apres;
    end

    %% ------------------------------------------------------------
    % SAUVEGARDE DES RESULTATS TEXTE
    %% ------------------------------------------------------------

    nom_base = nettoyer_nom(etape.titre);

    chemin_log = fullfile( ...
        dossier_resultats, ...
        [nom_base '.txt']);

    try

        fid = fopen(chemin_log, 'w');

        if fid ~= -1

            fprintf(fid, '%s\n\n', etape.titre);
            fprintf(fid, 'Script : %s\n\n', fichier);
            fprintf(fid, '%s', sortie);

            if ~execution_ok

                fprintf(fid, '\nERREUR :\n%s\n', erreur);

            end

            fclose(fid);

        end

    catch
    end

    %% ------------------------------------------------------------
    % SAUVEGARDE DES FIGURES
    %% ------------------------------------------------------------

    if sauver_figures && ~isempty(nouvelles_figures)

        fprintf('\nSauvegarde des figures :\n');

        for k = 1:length(nouvelles_figures)

            fig = nouvelles_figures(k);

            nom_fig = sprintf( ...
                '%s_%02d.fig', ...
                nom_base, ...
                k);

            nom_png = sprintf( ...
                '%s_%02d.png', ...
                nom_base, ...
                k);

            chemin_fig = fullfile( ...
                dossier_resultats, ...
                nom_fig);

            chemin_png = fullfile( ...
                dossier_resultats, ...
                nom_png);

            %% FIG MATLAB

            try

                savefig(fig, chemin_fig);

                fprintf('  [FIG] %s\n', nom_fig);

            catch
            end

            %% PNG

            try

                exportgraphics( ...
                    fig, ...
                    chemin_png, ...
                    'Resolution', ...
                    180);

                fprintf('  [PNG] %s\n', nom_png);

            catch

                try

                    saveas(fig, chemin_png);

                    fprintf('  [PNG] %s\n', nom_png);

                catch
                end

            end

        end

    end

    %% ------------------------------------------------------------
    % INFORMATIONS
    %% ------------------------------------------------------------

    fprintf('\n------------------------------------------------------------\n');

    if isempty(figures_apres)

        fprintf('Aucune figure ouverte pour cette question.\n');

    else

        fprintf('%d figure(s) Matlab actuellement ouverte(s).\n', ...
            length(figures_apres));

        fprintf('Vous pouvez les consulter avant de continuer.\n');

    end

    fprintf('Le Workspace Matlab reste accessible.\n');
    fprintf('------------------------------------------------------------\n\n');

    %% ------------------------------------------------------------
    % CHOIX
    %% ------------------------------------------------------------

    choix = choix_etape( ...
        'ENTREE = suivante | R = relancer | M = menu | Q = quitter');

    if strcmp(choix, 'rerun')

        continue;

    else

        action = choix;
        return;

    end

end

end


%% =================================================================
%% EXECUTION SIMULINK
%% =================================================================

function action = executer_simulink_etape( ...
    etape, ...
    dossier_TP, ...
    simuler_modele)

action = 'next';

while true

    fprintf('\n\n');
    fprintf('============================================================\n');
    fprintf('%s\n', etape.titre);
    fprintf('============================================================\n\n');

    fichier = chercher_fichier( ...
        etape.fichiers, ...
        dossier_TP);

    if isempty(fichier)

        fprintf('[MODELE NON TROUVE]\n\n');

        choix = choix_etape( ...
            'ENTREE = suivante | R = rechercher | M = menu | Q = quitter');

        if strcmp(choix, 'rerun')
            continue;
        else
            action = choix;
            return;
        end

    end

    fprintf('Modele : %s\n\n', fichier);

    ancien_dossier = pwd;
    dossier_modele = fileparts(fichier);

    try

        cd(dossier_modele);

        [~, nom_modele, ~] = fileparts(fichier);

        % Recharger les parametres existants : les questions font clear.
        % Les modeles utilisent les variables du Workspace principal.
        if strcmp(nom_modele, 'source_binaire')
            evalin('base', 'P = parametres_perso(''LABBE Emmy''); Tb = 1;');
        else
            parametres = chercher_fichier({'P3_parametres.m'}, dossier_TP);
            if isempty(parametres)
                error('TP:ParametresAbsents', 'P3_parametres.m introuvable.');
            end
            evalin('base', sprintf('run(''%s'');', ...
                strrep(parametres, '''', '''''')));
        end

        %% Chargement
        load_system(fichier);

        %% Ouverture
        open_system(nom_modele);

        fprintf('[OK] Modele Simulink ouvert.\n');

        %% Simulation
        if simuler_modele

            fprintf('Lancement de la simulation...\n');

            try

                assignin('base', 'out', sim(nom_modele));

                fprintf('[OK] Simulation terminee.\n');

            catch ME_SIM

                fprintf('\n[ATTENTION SIMULATION]\n');
                fprintf('%s\n\n', ME_SIM.message);

                fprintf(['Le modele reste ouvert. ' ...
                         'Vous pouvez le lancer manuellement.\n']);

            end

        end

        cd(ancien_dossier);

    catch ME

        cd(ancien_dossier);

        fprintf('\n[ERREUR SIMULINK]\n');
        fprintf('%s\n', ME.message);

    end

    fprintf('\nLe modele reste ouvert pour consultation.\n\n');

    choix = choix_etape( ...
        'ENTREE = suivante | R = relancer | M = menu | Q = quitter');

    if strcmp(choix, 'rerun')

        continue;

    else

        action = choix;
        return;

    end

end

end


%% =================================================================
%% ETAPE THEORIQUE
%% =================================================================

function action = afficher_etape_theorique(etape)

fprintf('\n\n');
fprintf('============================================================\n');
fprintf('%s\n', etape.titre);
fprintf('============================================================\n\n');

fprintf('%s\n', etape.texte);

action = choix_etape( ...
    'ENTREE = suivante | M = menu | Q = quitter');

end


%% =================================================================
%% RECHERCHE DE FICHIER
%% =================================================================

function fichier = chercher_fichier(noms, dossier_TP)

fichier = '';

for k = 1:length(noms)

    nom = noms{k};

    %% ------------------------------------------------------------
    % 1. Fichier directement dans le dossier du lanceur
    %% ------------------------------------------------------------

    chemin_direct = fullfile( ...
        dossier_TP, ...
        nom);

    if exist(chemin_direct, 'file') == 2

        fichier = chemin_direct;
        return;

    end

    %% ------------------------------------------------------------
    % 2. Recherche MATLAB WHICH
    %% ------------------------------------------------------------

    chemin_which = which(nom);

    if ~isempty(chemin_which)

        fichier = chemin_which;
        return;

    end

    %% ------------------------------------------------------------
    % 3. Recherche dans tous les sous-dossiers
    %% ------------------------------------------------------------

    resultat = dir( ...
        fullfile( ...
            dossier_TP, ...
            '**', ...
            nom));

    if ~isempty(resultat)

        for j = 1:length(resultat)

            if ~resultat(j).isdir

                %% Ignorer les dossiers de résultats
                if contains(resultat(j).folder, 'RESULTATS_TP') || ...
                   contains(resultat(j).folder, 'RESULTATS_FIGURES') || ...
                   contains(resultat(j).folder, 'slprj')

                    continue;

                end

                fichier = fullfile( ...
                    resultat(j).folder, ...
                    resultat(j).name);

                return;

            end

        end

    end

end

end


%% =================================================================
%% CHOIX APRES UNE ETAPE
%% =================================================================

function action = choix_etape(message)

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('%s\n', message);
fprintf('------------------------------------------------------------\n');

fprintf('ENTREE : continuer\n');
fprintf('R      : relancer cette etape\n');
fprintf('M      : revenir au menu principal\n');
fprintf('Q      : quitter le TP\n\n');

rep = lower(strtrim(input('Votre choix : ', 's')));

switch rep

    case ''
        action = 'next';

    case {'r','relancer','rerun'}
        action = 'rerun';

    case {'m','menu'}
        action = 'menu';

    case {'q','quit','quitter','exit'}
        action = 'quit';

    otherwise

        fprintf('\nCommande non reconnue -> continuation.\n');
        action = 'next';

end

end


%% =================================================================
%% ENTETE
%% =================================================================

function afficher_entete()

fprintf('\n');
fprintf('############################################################\n');
fprintf('#                                                          #\n');
fprintf('#       THEORIE DE L''INFORMATION ET DU CODAGE             #\n');
fprintf('#              TP MATLAB / SIMULINK                       #\n');
fprintf('#                                                          #\n');
fprintf('#              LABBE EMMY - 5A ASTRE                      #\n');
fprintf('#                                                          #\n');
fprintf('############################################################\n\n');

end


%% =================================================================
%% NETTOYAGE NOM DE FICHIER
%% =================================================================

function nom = nettoyer_nom(texte)

nom = regexprep( ...
    texte, ...
    '[^a-zA-Z0-9]', ...
    '_');

nom = regexprep( ...
    nom, ...
    '_+', ...
    '_');

nom = regexprep( ...
    nom, ...
    '^_|_$', ...
    '');

end


%% =================================================================
%% OUVRIR LES FIGURES
%% =================================================================

function ouvrir_figures(dossier_resultats)

fichiers = dir(fullfile( ...
    dossier_resultats, ...
    '*.fig'));

if isempty(fichiers)

    fprintf('\nAucune figure .fig sauvegardee.\n');
    pause(1);
    return;

end

fprintf('\nOuverture de %d figure(s)...\n', length(fichiers));

for k = 1:length(fichiers)

    chemin = fullfile( ...
        fichiers(k).folder, ...
        fichiers(k).name);

    try

        openfig(chemin, 'visible');

    catch

    end

end

fprintf('Figures ouvertes.\n');

pause(1);

end


%% =================================================================
%% OUVRIR DOSSIER RESULTATS
%% =================================================================

function ouvrir_dossier(dossier_resultats)

if ispc

    try

        winopen(dossier_resultats);

    catch

        fprintf('\nImpossible d''ouvrir automatiquement le dossier.\n');
        fprintf('%s\n', dossier_resultats);

    end

else

    fprintf('\nDossier :\n%s\n', dossier_resultats);

end

end


%% =================================================================
%% SORTIE
%% =================================================================

function afficher_sortie(dossier_resultats)

fprintf('\n\n');
fprintf('############################################################\n');
fprintf('#                                                          #\n');
fprintf('#                  FERMETURE DU TP                         #\n');
fprintf('#                                                          #\n');
fprintf('############################################################\n\n');

fprintf('Le lanceur a ete arrete proprement.\n');
fprintf('Les resultats deja obtenus sont conserves.\n\n');

fprintf('Dossier des resultats :\n');
fprintf('%s\n\n', dossier_resultats);

end
