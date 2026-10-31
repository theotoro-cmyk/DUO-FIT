(() => {
  const jokes = [
    'Ton collègue a mis tellement léger que la barre vient de demander un plaid.',
    'Vous soulevez surtout l’ambiance. Les disques attendent encore leur tour.',
    'Le seul truc lourd dans cette séance, c’est la vanne du collègue entre deux séries.',
    'Ton collègue appelle ça une série de chauffe. Ça fait six mois que ça préchauffe.',
    'Avec ces charges, même le parapluie reste fermé. Aucune tempête à l’horizon.',
    'La barre a demandé une augmentation. Elle estime ne pas être assez chargée de travail.',
    'Vous vous chambrez sur les kilos, mais votre record commun reste la pause entre deux séries.',
    'Le collègue compte les répétitions. Surtout celles de la phrase « aujourd’hui, j’y vais tranquille ».',
    'La seule surcharge progressive ici, c’est le nombre de blagues nulles.'
  ];
  let index = Math.floor(Math.random() * jokes.length);
  let taps = 0, reset;
  const dialog = document.createElement('dialog');
  dialog.id = 'banterDialog';
  dialog.setAttribute('aria-labelledby', 'banterTitle');
  dialog.innerHTML = '<button type="button" class="banter-close" aria-label="Fermer la blague">Fermer</button><div class="banter-icon" aria-hidden="true">☂</div><h2 id="banterTitle">Alerte : vanne lourde.</h2><p id="banterText"></p><p class="banter-note">On chambre les barres. Chacun garde son rythme.</p><button type="button" class="primary" id="nextBanter">Encore une couche</button>';
  document.body.appendChild(dialog);
  function next() { document.getElementById('banterText').textContent = jokes[index++ % jokes.length]; }
  function open() { next(); if (!dialog.open) dialog.showModal(); }
  dialog.querySelector('.banter-close').onclick = () => dialog.close();
  dialog.querySelector('#nextBanter').onclick = next;
  dialog.addEventListener('click', e => { if (e.target === dialog) dialog.close(); });
  document.getElementById('umbrellaSecret').onclick = open;
  document.querySelector('.brand').addEventListener('click', e => {
    e.preventDefault();
    clearTimeout(reset);
    if (++taps === 3) { taps = 0; open(); }
    reset = setTimeout(() => { taps = 0; }, 1600);
  });
})();
