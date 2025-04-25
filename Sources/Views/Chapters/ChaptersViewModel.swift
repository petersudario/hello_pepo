//
//  ChaptersViewModel.swift
//  Meet Pepo
//
//  Created by Pedro Henrique Sudario da Silva on 21/04/25.
//

import Combine
import Foundation

final class ChaptersViewModel: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var selectedChapterIndex = 0
    @Published var selectedSectionIndex = 0

    @Published var titleUnlockedIndex: Int
    @Published var memoryUnlockedIndex: Int

    private let defaults = UserDefaults.standard
    private let kTitleKey = "titleUnlockedIndex"
    private let kMemoryKey = "memoryUnlockedIndex"

    init() {
        chapters = [
            Chapter(title: "Blue", reference: "- Is that the right color?", modelName: "all_star", soundFileName: "", contents: [
                .text(text: "", audioFileName: "")
            ]),
            Chapter(
                title: "Black box",
                reference: "- Where everything started",
                modelName: "ps2",
                soundFileName: "ps2.mp3",
                contents: [
                    .text(text: "Eu era muito pequeno quando essa história começou. Mais ou menos em 2007 ou 2008.",
                          audioFileName: "audio1_1.m4a"),
                    .text(text: "Lembro de voltar de carro para casa junto do meu pai, eu tava bem cansado.",
                          audioFileName: "audio1_2.m4a"),
                    .text(text: "Era por volta das 16h ou 17h em algum dia no meio da semana, tipo uma quarta‑feira.",
                          audioFileName: "audio1_3.m4a"),
                    .text(text: "Entrei em casa....não tinha absolutamente nada para fazer",
                          audioFileName: "audio1_3_1.m4a"),
                    .text(text: "Eu fui para um cômodo diferente e quando voltei para a sala, vi meu pai olhando para uma Ferrari na televisão.",
                          audioFileName: "audio1_4.m4a"),
                    .text(text: "Nem sabia que era uma Ferrari, mas sabia que era um carro.",
                          audioFileName: "audio1_5.m4a"),
                    .text(text: "Mas o carro parecia diferente, parecia de massinha e um pouco poligonal.",
                          audioFileName: "audio1_6.m4a"),
                    .text(text: "Olhei para a estante, e vi o que parecia ser uma caixa preta com um LED aceso.",
                          audioFileName: "audio1_7.m4a"),
                    .text(text: "Até que meu pai finalmente explicou, depois de me ver muito confuso, que aquilo era um videogame.",
                          audioFileName: "audio1_8.m4a"),
                    .text(text: "Ele comprou o meu primeiro videogame. O PlayStation 2.",
                          audioFileName: "audio1_9.m4a"),
                    .text(text: "A partir desse momento, eu nunca mais larguei um videogame.",
                          audioFileName: "audio1_10.m4a"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Jill Sandwich", reference: "- Fearless", modelName: "resident_evil", soundFileName: "re4_spinel.mp3", contents: [
                .text(text: "Ainda em 2009, com o mesmo PlayStation. Minha irmã tinha acabado de comprar um jogo novo pro videogame.", audioFileName: "audio2_1.m4a"),
                .text(text: "O nome da franquia é Resident Evil", audioFileName: "audio2_2.m4a"),
                .text(text: "Eu era bem medroso com filmes e jogos de terror. Mas tinha uma sensação diferente sobre o jogo que ela tinha comprado.", audioFileName: "audio2_3.m4a"),
                .text(text: "Eu tinha medo, mas queria muito jogar.", audioFileName: "audio2_4.m4a"),
                .text(text: "Em vez disso eu fiquei vendo minha irmã jogar por um tempo, até ela me deixar jogar.", audioFileName: "audio2_5.m4a"),
                .text(text: "Passei horas e horas jogando, e se tornou o jogo mais memorável da minha vida.", audioFileName: "audio2_6.m4a"),
                .text(text: "E eu descobri que não tinha medo de jogos assim", audioFileName: "audio2_7.m4a"),
                .text(text: "É uma história curta, mas tem um valor especial pra mim.", audioFileName: "audio2_8.m4a"),
                .text(text: "Porque eu jogo a mesma coisa, durante 17 anos, pelo menos uma vez por ano.", audioFileName: "audio2_9.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Jackpot!", reference: "- Where the son cries and the mom doens't see", modelName: "dante", soundFileName: "jackpot!.mp3", contents: [
                .text(text: "Foi em 2009. Já estava acostumado com jogos de terror e Heck 'n' Slash.", audioFileName: "audio3_1.m4a"),
                .text(text: "Achei o jogo na estante, que aparentemente era da minha irmã.", audioFileName: "audio3_2.m4a"),
                .text(text: "Parecia ser de terror, não pensei duas vezes em rodar o jogo no PS2", audioFileName: "audio3_3.m4a"),
                .text(text: "As gráficos já não eram poligonais e nem de massinha, eram incríveis!", audioFileName: "audio3_4.m4a"),
                .text(text: "Lembro de passar dias no mesmo chefe do jogo.", audioFileName: "audio3_5.m4a"),
                .text(text: "Pense em uma criança mimada e que se irrita fácil, jogando Devil Mau Cry.", audioFileName: "audio3_6.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Polygons", reference: "- Going back in time", modelName: "spyro", soundFileName: "spyro.mp3", contents: [
                .text(text: "Esse fato é muito curioso", audioFileName: "audio4_1.m4a"),
                .text(text: "Durante um ponto da minha vida, por alguma razão, eu deixei ter um PS2.", audioFileName: "audio4_2.m4a"),
                .text(text: "Não se sabe o porque isso aconteceu. Talvez porque perdi muitas coisas indo morar com a minha mãe.", audioFileName: "audio4_3.m4a"),
                .text(text: "Era por volta de 2010. Morava numa cidade onde o tempo era parado.", audioFileName: "audio4_4.m4a"),
                .text(text: "Cidade onde um Samsung de teclado escorregante era novidade, quando o iPhone 4 já tinha lançado.", audioFileName: "audio4_5.m4a"),
                .text(text: "Mas, apesar de voltar no tempo, eu tive uma experiência incrível com o PlayStation 1.", audioFileName: "audio4_6.m4a"),
                .text(text: "Foi o primeiro videogame relativamente antigo que eu tive, com gráficos extremamente poligonais.", audioFileName: "audio4_7.m4a"),
                .text(text: "E tive ele com um dos jogos poligonais mais memoráveis que já existiu na geração..", audioFileName: "audio4_8.m4a"),
                .text(text: "O Spyro.", audioFileName: "audio4_9.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Bombs", reference: "- and a lot of walls", modelName: "Bomberman", soundFileName: "bomberman.mp3", contents: [
                .text(text: "Eu queria muito muito muito falar sobre Bomberman.", audioFileName: "audio11_1.m4a"),
                .text(text: "Foi o primeiro jogo dedicado para videogames da Nintendo que joguei na vida..", audioFileName: "audio11_2.m4a"),
                .text(text: "Mas em um PS1 desbloqueado!", audioFileName: "audio11_3.m4a"),
                .text(text: "Passava as férias de meio de ano inteiras, jogando Bomberman SNES.", audioFileName: "audio11_4.m4a"),
            ]),
            Chapter(title: "Professional Screamer", reference: "- The champion", modelName: "forza_ferrari", soundFileName: "r25.mp3", contents: [
                .text(text: "Aqui iniciou o meu gosto por carros. Especialmente por Formula 1. 2009 para 2012", audioFileName: "audio5_1.m4a"),
                .text(text: "Eu tenho um tio que eu não gostava muito a principio, quando eu era criança.", audioFileName: "audio5_2.m4a"),
                .text(text: "Ele só falava de jornal, futebol e caminhão.", audioFileName: "audio5_3.m4a"),
                .text(text: "Nunca gostava de escutar os assuntos dele, e ele também era meio bravo.", audioFileName: "audio5_4.m4a"),
                .text(text: "Mas teve um dia em específico que isso foi diferente.", audioFileName: "audio5_5.m4a"),
                .text(text: "Um dia vi ele muito feliz, rindo da televisão, olhando para um carro de Formula 1.", audioFileName: "audio5_6.m4a"),
                .text(text: "Ele tava rindo da narrativa do Galvão Bueno, sobre o Sebastian Vettel, tetra campeão de formula 1." , audioFileName: "audio5_7.m4a"),
                .text(text: "Umas semanas depois, eu resolvi assistir junto a ele e entender o que era uma Formula 1.", audioFileName: "audio5_8.m4a"),
                .text(text: "Desde então, eu não parei mais de assistir e de torcer para a Red Bull e McLaren.", audioFileName: "audio5_9.m4a"),
                .modelPreview
                
            ]),
            Chapter(title: "Shadows", reference: "- Even the biggest can fall", modelName: "lightsword_sotc", soundFileName: "agro!.mp3", contents: [
                
                .text(text: "Este jogo é uma memória especial para mim. Tinha um PS2 novamente.", audioFileName: "audio6_1.m4a"),
                .text(text: "Todos os jogos que já joguei quando criança, eu pude jogar novamente como adulto.", audioFileName: "audio6_2.mp4"),
                .text(text: "Exceto esse.", audioFileName: "audio6_3.m4a"),
                .text(text: "Shadow of the Colossus, parecia ser um jogo que conversava comigo.", audioFileName: "audio6_4.m4a"),
                .text(text: "Foi a primeira vez que, parei horas na frente da TV de tubo..", audioFileName: "audio6_5.m4a"),
                .text(text: "Escutando as músicas e os efeitos sonoros..", audioFileName: "audio6_6.m4a"),
                .text(text: "E explorando o mundo aberto. Vazio mas imensamente bonito.", audioFileName: "audio6_7.m4a"),
                .text(text: "Também foi o primeiro jogo de mundo aberto que joguei na vida, por volta de 2012.", audioFileName: "audio6_8.m4a"),
                .text(text: "Eu joguei até o fim, uma única vez, e nunca mais tive o videogame ou o jogo.", audioFileName: "audio6_9.m4a"),
                .text(text: "Foi uma experiência única em vida que já tive.", audioFileName: "audio6_10.m4a"),
                .modelPreview
            ]),
            Chapter(title: "The neighborhood friend", reference: "- The best hero", modelName: "spiderman", soundFileName: "you_are_a_mistake.mp3", contents: [

                .text(text: "Minha infância inteira eu era fissurado no Spider-Man.", audioFileName: "audio7_3.m4a"),
                .text(text: "Eu tinha cada jogo e cada CD dos filmes, gravados em casa.", audioFileName: "audio7_4.m4a"),
                .text(text: "Amava as animações, as HQ's, tudo sobre ele.", audioFileName: "audio7_5.m4a"),
                .text(text: "O PS2 era estampado com o homem aranha no filtro de pôr de sol.", audioFileName: "audio7_6.m4a"),
                .text(text: "Nos dias atuais, eu ainda assisto os novos filmes atuados pelo Tom Holland e as animações da Sony.", audioFileName: "audio7_7.m4a"),
                .text(text: "Para mim, ser o homem aranha não é sobre ser um herói..", audioFileName: "audio7_8.m4a"),
                .text(text: "Mas sobre ser amigo das pessoas e honesto. Eu tento ser assim.", audioFileName: "audio7_9.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Look for the eye", reference: "- A programmer in ascension", modelName: "enderman", soundFileName: "enderman.mp3", contents: [
                .text(text: "Em 2013 mesmo, eu descobri um jogo que mantém seu legado até hoje..", audioFileName: "audio8_1.m4a"),
                .text(text: "Tempo passou. 2015. Aposentei o PlayStation 2, e cansei de jogar no Xbox 360.", audioFileName: "audio8_2.m4a"),
                .text(text: "Finalmente começei a me adentrar no mundo digital", audioFileName: "audio8_3.m4a"),
                .text(text: "Eu entrei em um servidor de Minecraft pela primeira vez", audioFileName: "audio8_4.m4a"),
                .text(text: "Nome do servidor era MzCraft.", audioFileName: "audio8_5.m4a"),
                .text(text: "Até então, eu só conhecia os mundos tradicionais do Minecraft.", audioFileName: "audio8_6.m4a"),
                .text(text: "Quando eu tive essa descoberta, logo em 2015, eu me interessei muito pela criação de servidores.", audioFileName: "audio8_7.m4a"),
                .text(text: "Eu passava madrugadas e madrugadas no Skype com meus amigos durante as férias, criando servidores.", audioFileName: "audio8_8.m4a"),
                .text(text: "Java ali, Spigot lá, Craftbukkit não sei onde..", audioFileName: "audio8_9.m4a"),
                .text(text: "Eu tinha começado a mexer com programação, sem saber que era programação! Obrigado Notch!", audioFileName: "audio8_10.m4a"),
                .modelPreview

            ]),
            Chapter(title: "I'm still alive!", reference: "- Being a pirate", modelName: "wheatley", soundFileName: "spaaaace.mp3", contents: [
                .text(text: "Era 2016. Eu e minha mãe não tinhamos dinheiro.", audioFileName: "audio9_1.m4a"),
                .text(text: "Eu queria muito, jogos que as pessoas jogavam durante a geração", audioFileName: "audio9_2.m4a"),
                .text(text: "Foi nessa época que, entrei numa área um tanto complicada da tecnologia: pirataria.", audioFileName: "audio9_3.m4a"),
                .text(text: "Ao mesmo tempo que descobri meios pra ter diversão no computador..", audioFileName: "audio9_4.m4a"),
                .text(text: "Eu descobri que a segurança e privacidade online é o maior privilégio que podemos ter.", audioFileName: "audio9_5.m4a"),
                .text(text: "Consegui piratear meu primeiro jogo de forma segura e razoavelmente ética.", audioFileName: "audio9_6.m4a"),
                .text(text: "Portal 2 foi um dos ápices de puzzles.", audioFileName: "audio9_7.m4a"),
                .text(text: "....Ah e eu odeio essa bola de metal maldita!", audioFileName: "audio9_8.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Masquerade Fun", reference: "- Going back in time (again)", modelName: "link", soundFileName: "link.mp3", contents: [
                .text(text: "Ainda em 2016. Tive um novo delírio junto dos meus amigos do fundamental: Nintendo.", audioFileName: "audio10_1.m4a"),
                .text(text: "Eu não tive muito contato com videogames da Nintedo durante a infância", audioFileName: "audio10_2.m4a"),
                .text(text: "Gameboys, 3DS e Gamecube ainda eram novidades para mim.", audioFileName: "audio10_3.m4a    "),
                .text(text: "Na época eu só conhecia Super Mario e Donkey Kong, não fazia ideia de quem era a Nintendo.", audioFileName: "audio10_5.m4a"),
                .text(text: "Meus amigos me mostraram emuladores de celular que eu podia jogar alguns jogos", audioFileName: "audio10_4.m4a"),
                .text(text: "Joguei a fraquia Zelda pela primeira vez, no Majora's Mask!", audioFileName: "audio10_5.m4a"),
                .text(text: "Me senti abraçado pela ambientação do jogo, calma e mais natural.", audioFileName: "audio10_6.m4a"),
                .text(text: "Me senti mais criança novamente.", audioFileName: "audio10_7.m4a"),
                
                .modelPreview

            ]),
            Chapter(title: "Blasters and Swords", reference: "- Learn the force you should", modelName: "lightsaber", soundFileName: "lightsaber.mp3", contents: [
                .text(text: "Eu sempre. SEMPRE. Quis ser um Jedi!", audioFileName: "audio12_1.m4a"),
                .text(text: "Pena que não consigo levantar pedras com o poder da mente e usar uma espada laser..", audioFileName: "audio12_2.m4a"),
                
                .modelPreview

            ]),
            Chapter(title: "God and void", reference: "- The dark is not always bad.", modelName: "hollow_knight", soundFileName: "hollow_knight_scream.mp3", contents: [
                .text(text: "2020. Aqui eu já estava me aproximando da maioridade, já não era extremamente fissurado em jogos, mas sim em cinema, histórias, livros e backstory.", audioFileName: "audio13_1.m4a"),
                .text(text: "A partir daqui, as histórias e acontecimentos que tive, me definiram como pessoa.", audioFileName: "audio13_2.m4a"),
                .text(text: "Um amigo, do ensino fundamental, me recomendou um jogo. Uma mecânica simples de plataforma e ataque.", audioFileName: "audio13_4.m4a"),
                .text(text: "Ele falou para eu só jogar, e não pedir nenhum spoiler.", audioFileName: "audio13_5.m4a"),
                .text(text: "Eu era extremamente chato e exigente, só experimentava as coisas quando eu sabia claramente que era bom", audioFileName: "audio13_6.m4a"),
                .text(text: "E foi o meu maior arrependimento ser assim.", audioFileName: "audio13_6.m4a"),
                .text(text: "Hollow Knight foi um dos jogos que me deixou por horas, MAS HORAS MESMO, olhando para o monitor..", audioFileName: "audio13_7.m4a"),
                .text(text: "Sem perceber que eu havia jogado uma das maiores obras Kickstarter do século no mundo dos jogos.", audioFileName: "audio13_8.m4a"),
                .text(text: "A história me ensinou que, a escuridão nem sempre é ruim..", audioFileName: "audio13_9.m4a"),
                .text(text: "..nem sempre a luz é boa..", audioFileName: "audio13_10.m4a"),
                .text(text: "..nem sempre existem certos ou errados na história.", audioFileName: "audio13_11.m4a"),
                .text(text: "Mas que existem consequências para os seus atos e os dos outros.", audioFileName: "audio13_12.m4a"),
                .text(text: "Esse jogo foi o único que me fez cair uma lágrima quando terminei de jogar.", audioFileName: "audio13_13.m4a"),
                .modelPreview

            ]),
            Chapter(title: "Dodging life", reference: "- Beating up the stress", modelName: "boxing_gloves", soundFileName: "", contents: [
                .text(text: "Pandemia.", audioFileName: "audio14_1.m4a"),
                .text(text: "Estresse dentro de casa, inseguranças, preocupações com o futuro.", audioFileName: "audio14_2.m4a"),
                .text(text: "Eu precisava achar alguma válvula de escape que não fossem atividades dentro de casa.", audioFileName: "audio14_3.m4a"),
                .text(text: "Eu tinha muito interesse em artes marciais..", audioFileName: "audio14_4.m4a"),
                .text(text: "Gostava muito de ver o Muhammad Ali dar seus discursos em vídeos antigos..", audioFileName: "audio14_5.m4a"),
                .text(text: "e claramente gostava muito de Street Fighter.", audioFileName: "audio14_6.m4a"),
                .text(text: "Comprei um par de luvas e comecei a treinar Muay Thai e Boxe", audioFileName: "audio14_7.m4a"),
                .text(text: "Ainda pretendo voltar a treinar hoje em dia.", audioFileName: "audio_14_8.m4a"),
                .modelPreview
            ]),

            Chapter(title: "Boredom, sparks & monsters", reference: "- What to do on a quarantine?", modelName: "meowmere", soundFileName: "meowmere.mp3", contents: [
                .text(text: "Quando fosse a hora de descansar, eu queria algo diferente pra fazer na pandemia.", audioFileName: "audio15_1.m4a"),
                .text(text: "O quanto eu conseguiria bater no tédio dentro de casa?", audioFileName: "audio15_2.m4a"),
                .text(text: "Eu encontrei um jogo maravilhoso, que ainda jogo atualmente, chamado Terraria.", audioFileName: "audio15_3.m4a"),
                .text(text: "Eu fui atraido por varias peculiaridades do jogo, como uma espada-gato.", audioFileName: "audio15_4.m4a"),
                .text(text: "O jogo era um terror de coisas brilhantes com purpurina e monstros.", audioFileName: "audio15_5.m4a"),
                .text(text: "Foram as 587 horas mais perfeitas de 2021.", audioFileName: "audio15_6.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Fire and resentment", reference: "- What if feels like to grow up" , modelName: "bonfire", soundFileName: "bonfire_lit.mp3", contents: [
                .text(text: "Fim da pandemia em 2022. Eu não via muitos rostos diferentes desde 2020.", audioFileName: "audio16_1.m4a"),
                .text(text: "Já estava beirando os 18 anos.", audioFileName: "audio16_2.m4a"),
                .text(text: "No início de 2022, eu passei por más experiências durante a vida, e não sabia como lidar com isso.", audioFileName: "audio16_3.m4a"),
                .text(text: "Já não era mais tão simples resolver as coisas com as pessoas, muito menos conversar.", audioFileName: "audio16_4.m4a"),
                .text(text: "Eu era uma pessoa que desistia fácilmente, caso as coisas ficassem complicadas na vida.", audioFileName: "audio16_6.m4a"),
                .text(text: "Na mesma época, eu encontrei uma franquia que escutei falarem milhares de vezes.", audioFileName: "audio16_5.m4a"),
                .text(text: "Dark souls aquilo, dark souls não sei o que..", audioFileName: "audio16_6.m4a"),
                .text(text: "Não sei porque eu decidi ir jogar essa franquia, não tinha nada a ver com o que se passava comigo.", audioFileName: "audio16_7.m4a"),
                .text(text: "Até que eu entendi que tinha.", audioFileName: "audio16_8.m4a."),
                .text(text: "Dark souls era um jogo sobre um mundo decadente, quente e também congelante.",
                    audioFileName: "audio16_9.m4a"),
                .text(text: "Com pessoas frias, criaturas frias, totalmente inóspito e cruel.", audioFileName: "audio16_10.m4a"),
                .text(text: "E eu ja era maduro suficiente pra entender que..", audioFileName: "audio16_11.m4a"),
                .text(text: "O mundo era cruel, e você tem que seguir em frente.", audioFileName: "audio16_12.m4a"),
                .text(text: "Mas o mundo também pode ser recomfortante, e você tem que seguir em frente.", audioFileName: "audio16_13.m4a"),
                .text(text: "Siga em frente, tente denovo, descanse em uma fogueira..", audioFileName: "audio16_13.m4a"),
                .text(text: "Dark souls não foi só um joguinho qualquer que era muito dificil para mim..", audioFileName: "audio16_14.m4a"),
                .text(text: "Foi uma lição de vida.", audioFileName: "audio16_15.m4a"),

                .modelPreview
            ]),
            Chapter(
                title: "Fire and scars",
                reference: "- A tough time",
                modelName: "Berserk_Armor",
                soundFileName: "berserk_clang.mp3",
                contents: [
                    .text(text: "Fire and resentment parte 2.", audioFileName: ".m4a"),
                    .text(text: "Na mesma época eu conheci a inspiração por trás da criação da franquia Dark souls.", audioFileName: "audio17_1.m4a"),
                    .text(text: "Era um mangá extremamente esquisito para maiores de 18 anos.", audioFileName: "audio17_2.m4a"),
                    .text(text: "Não vou entrar em detalhes sobre, mas era um mangá cruel, assim como o jogo.", audioFileName: "audio17_3.m4a"),
                    .text(text: "O protagonista era um espadachim com uma espada de mais de 100KG, cheio de cicatrizes...", audioFileName: "audio17_4.m4a"),
                    .text(text: "..que pareciam doer como fogo.", audioFileName: "audio17_4_1.m4a"),
                    .text(text: "E usava uma armadura amaldiçoada com uma viseira vermelha.", audioFileName: "audio17_5.m4a"),
                    .text(text: "Eu comecei a me aprofundar, ler o mangá, os detalhes da franquia..", audioFileName: "audio17_6.m4a"),
                    .text(text: "E muita coisa fez sentido para mim (exceto as partes esquisitas da história).", audioFileName: "audio17_7.m4a"),
                    .text(text: "O protagonista tinha um mente inabalavel. Mas ele nunca foi assim desde sempre.", audioFileName: "audio17_8.m4a"),
                    .text(text: "Ele perdeu pessoas, perdeu a paz, perdeu momentos bons..", audioFileName: "audio17_9.m4a"),
                    .text(text: "Mas ainda sim, ele continuou lutando pela própria vida..", audioFileName: "audio17_10.m4a"),
                    .text(text: "E pela vida dos outros que eram gratos a ele.", audioFileName: "audio17_11.m4a"),
                    .text(text: "O maior ensinamento que já tive na vida, e que esse mangá e jogo realmente me ajudou..", audioFileName: "audio17_11.m4a"),
                    .text(text: "Foi que a persistência, o foco, a obscessão em ser a sua melhor versão..", audioFileName: "audio17_12.m4a"),
                    .text(text: "Te transforma em algo extraordinário.", audioFileName: "audio17_13.m4a"),
                    .modelPreview
                ]
            ),
            Chapter(title: "Warmth", reference: "- When you feel like you again", modelName: "malenia", soundFileName: "malenia.mp3", contents: [
                .text(text: "Proveniente de Dark Souls e também Berserk. ELDEN RING.", audioFileName: "audio18_1.m4a"),
                .text(text: "Queria muito homenagear a maior obra de arte que já joguei na vida.", audioFileName: "audio18_2.m4a"),
                .text(text: "Pra mim, foi o ápice da história de Hidetaka Miyazaki e maior exemplo de pensamento filosófico que eu sigo!", audioFileName: "audio18_3.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Sour & Energy", reference: "- A W-O-N-D-E-R-F-U-L drink.", modelName: "monster", soundFileName: "bloxcola_sound.mp3", contents: [
                .text(text: "A BEBIDA NÃO-SAUDAVEL PERFEITA!", audioFileName: "audio19_1.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Out of the world", reference: "- You should hear more music", modelName: "virtuoso", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "Meu método de hiperfoco: a música.", audioFileName: "audio20_1.m4a"),
                .text(text: "Eu simplesment esqueço que existo no mundo, e consigo criar coisas inimagináveis escutando música.", audioFileName: "audio20_2.m4a"),
                .text(text: "Comprei esse fone com meu primeiro salário como estagiário.", audioFileName: "audio20_3.m4a"),
                .text(text: "Me salvou anos de estresse e de daydreaming", audioFileName: "audio20_4.m4a"),
                .modelPreview
            ]),
            Chapter(title: "Friends", reference: "- The best gift ever", modelName: "akira", soundFileName: "akira.mp3", contents: [
                .text(text: "No meu aniversário de 20 anos, em 2024, eu ganhei uma coleção de mangás.", audioFileName: "audio21_1.m4a"),
                .text(text: "Foram todos os meus amigos que se organizaram e me deram de presente.", audioFileName: "audio21_2.m4a"),
                .text(text: "Foi o melhor presente que já ganhei na vida.", audioFileName: "audio21_3.m4a"),
                .text(text: "Não não! Não estou falando dos mangás, estou falando dos meus amigos!", audioFileName: "audio21_4.m4a"),
                .text(text: "Eles que são o melhor presente!", audioFileName: "audio21_5.m4a"),
                
                .modelPreview
            ]),
            Chapter(title: "Colors and Logic", reference: "- 1 billion problems, 1 pattern.", modelName: "rubiks_cube", soundFileName: "pop_sound.mp3", contents: [
                .text(text: "Em 2024 eu entrei em uma empresa, na minha primeira vaga como desenvolvedor, aos 21 anos.", audioFileName: "audio22_1.m4a"),
                .text(text: "Eu percebi, assim que entrei, que todo mundo tinha um cubo mágico.", audioFileName: "audio22_2.m4a"),
                .text(text: "Tinha quadros de cubo mágico e suportes de cubo mágico!", audioFileName: "audio22_3.m4a"),
                .text(text: "Até que eu entendi que o cubo mágico não era um simples brinquedo.", audioFileName: "audio22_4.m4a"),
                .text(text: "Pense na possibilidade: um bloco com mais de 1 milhão de problemas...", audioFileName: "audio22_5.m4a"),
                .text(text: "que você pode resolver em segundos se souber o que está fazendo.", audioFileName: "audio22_6.m4a"),
                .text(text: "É a personificação de um desenvolvedor!", audioFileName: "audio22_7.m4a")
            ]),
            Chapter(title: "Never give up", reference: "- Keep reaching the horizon", modelName: "macbook", soundFileName: "macbook.mp3", contents: [
                .text(text: "Como eu disse antes, eu aprendi muito.", audioFileName: "audio23_1.m4a"),
                .text(text: "E o que eu aprendi de melhor, é nunca desistir.", audioFileName: "audio23_2.m4a"),
                .text(text: "Eu achei que nunca ia tocar em um Macbook ou iPhone.", audioFileName: "audio23_3.m4a"),
                .text(text: "Em 2025 isso foi diferente. Porque eu não desisti.", audioFileName: "audio23_4.m4a"),
                .modelPreview
            ]),

            Chapter(title: "Back to the start", reference: "", modelName: "gamecube", soundFileName: "gamecube.mp3", contents: [
                .text(text: "Assim como lá no inicio, a história se inicia novamente com um videogame.", audioFileName: "audio24_1.m4a"),
                .text(text: "17 anos atrás, um videogame definiu o que sou hoje.", audioFileName: "audio24_2.m4a"),
                .text(text: "Acabei de comprar um Gamecube. Original, japonês, sem jogos, não desbloqueado.", audioFileName: "audio24_3.m4a"),
                .text(text: "Será que a história vai ficar cada vez melhor?", audioFileName: "audio24_4.m4a"),
                .modelPreview
            ]),
            
        ]

        // Registrar default para título
        defaults.register(defaults: [kTitleKey: 0])
        titleUnlockedIndex = defaults.integer(forKey: kTitleKey)

        // Restaurar progresso de memória ou definir como -1
        if defaults.object(forKey: kMemoryKey) != nil {
            memoryUnlockedIndex = defaults.integer(forKey: kMemoryKey)
        } else {
            memoryUnlockedIndex = -1
        }
    }

    func nextSection() {
        let total = chapters[selectedChapterIndex].contents.count
        if selectedSectionIndex + 1 < total {
            selectedSectionIndex += 1
        }
    }

    func nextChapter() {
        if selectedChapterIndex + 1 < chapters.count {
            selectedChapterIndex += 1
            selectedSectionIndex = 0
        }
    }

    func collectMemory() {
        memoryUnlockedIndex = max(memoryUnlockedIndex, selectedChapterIndex)
        defaults.set(memoryUnlockedIndex, forKey: kMemoryKey)

        let next = selectedChapterIndex + 1
        if next < chapters.count {
            titleUnlockedIndex = max(titleUnlockedIndex, next)
            defaults.set(titleUnlockedIndex, forKey: kTitleKey)
        }

    }
}
