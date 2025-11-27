// Representa al gestor de sonido
public class AudioManager {
    private Minim minim;
    private AudioPlayer titulo;
    private AudioPlayer juego;
    private AudioPlayer derrota;
    private AudioPlayer victoria;

    public AudioManager(PApplet app) {
        minim = new Minim(app);
        titulo = minim.loadFile("musicaTitulo.mp3");
        juego = minim.loadFile("musicaJuego.mp3");
        derrota = minim.loadFile("musicaDerrota.mp3");
        victoria = minim.loadFile("musicaVictoria.mp3");
        
        
        titulo.setGain(-10);
        juego.setGain(-10);
    }

    // --- Metodos publicos ---
    public void playTitulo() { stopAll(); titulo.play(); }
    public void playJuego() { stopAll(); juego.loop(); }
    public void playDerrota() { stopAll(); derrota.play(); }
    public void playVictoria() { stopAll(); victoria.play(); }

    // --- Getters ---
    public AudioPlayer getTitulo() { return titulo; }
    public AudioPlayer getJuego() { return juego; }
    public AudioPlayer getDerrota() { return derrota; }
    public AudioPlayer getVictoria() { return victoria; }

    // --- Metodo privado ---
    private void stopAll() {
        titulo.pause(); juego.pause(); derrota.pause(); victoria.pause();
        titulo.rewind(); juego.rewind(); derrota.rewind(); victoria.rewind();
    }
}
