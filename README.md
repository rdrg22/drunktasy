# ESTO ES DRUNKTASY

Liga privada de copas y anécdotas para la cuadrilla. Web app móvil en un único `index.html`, sin instalar nada.

## En marcha

- **Web**: https://rdrg22.github.io/drunktasy/ (GitHub Pages, rama `main`). Ese enlace es el que se manda al grupo.
- **Base de datos**: Supabase, proyecto «rdrg22's Project», tablas `ddv_` creadas con `schema.sql`.
  La URL y la *anon key* van fijas en `CONFIG` al principio del `<script>` de `index.html`.

Para montarla en otro sitio: ejecuta `schema.sql` en un proyecto de Supabase, cambia `CONFIG` (o déjalo vacío y
conecta desde «¿Quién eres?» → *Redacción*, que genera un enlace `#sb=…&k=…` con la conexión dentro) y sube
`index.html` a cualquier hosting estático.

Sin Supabase funciona en **modo prueba**: los datos se quedan en ese navegador.

## Reglas

| Bebida | Pts | Anécdota | Pts |
|---|---|---|---|
| Caña / cerveza | 1 | Audio vergonzoso | 3 |
| Vino | 1 | Escribir al ex | 5 |
| Cubata | 2 | Perder algo | 3 |
| Chupito | 2 | Dormirse en sofá ajeno | 2 |
| «Lo raro» | 3 | Chapa a un desconocido | 2 |

- Las categorías personalizadas las crea cualquiera (1–10 pts).
- Confesar una anécdota propia cuenta al momento. Delatar a otro la deja **PENDIENTE DE JUICIO**: el chivato vota culpable de oficio y gana la mayoría simple del resto del grupo (sin contar al acusado).
- La temporada es el mes natural. El ranking se reinicia solo y los meses pasados quedan en *Archivo*.
- Medallas: El Fantasma (cero actividad en el mes), El Filósofo de las 4AM (2+ registros entre las 3 y las 6), El Que Siempre Dice La Última (cierra 2+ noches) y Reincidente (3 meses en el podio).
- «Retractarse» pide doble toque: el primero avisa, el segundo borra.

⚠️ No hay contraseñas: quien tenga el enlace puede leer y escribir. No lo pongas en un grupo de 200 personas.
