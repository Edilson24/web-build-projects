package util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class AvatarUtil {

    /**
     * Retorna a foto do usuário ou gera a URL do ui-avatars.com caso a foto seja nula/vazia[cite: 5, 6].
     */
    public static String obterFoto(String fotoUrl, String nome) {
        if (fotoUrl != null && !fotoUrl.trim().isEmpty()) {
            return fotoUrl;
        }

        String nomeFormatado = (nome != null && !nome.trim().isEmpty()) ? nome.trim() : "Usuario";
        String nomeEncoded = URLEncoder.encode(nomeFormatado, StandardCharsets.UTF_8);

        // Cores padrão do sistema: Azul (#003366) e Texto Branco (#FFFFFF)[cite: 5, 6]
        return "https://ui-avatars.com/api/?name=" + nomeEncoded + "&background=003366&color=ffffff&size=128";
    }
}