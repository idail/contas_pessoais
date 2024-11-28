Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHorizontalCard(
                context,
                icon: Icons.money_rounded,
                title: 'Renda',
                buttonLabel: 'Cadastrar',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 16.0,
                        backgroundColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 500,
                            maxWidth: 400,
                          ),
                          child: CadastroRendaPage(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 10.0),
              _buildHorizontalCard(
                context,
                icon: Icons.account_balance_wallet,
                title: 'Despesa',
                buttonLabel: 'Cadastrar',
                onPressed: () {
                  print('Card 2 pressionado');
                },
              ),
            ],
          ),


          Widget _buildHorizontalCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 0.0, // Removendo sombra extra para seguir o estilo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 210.0, // Largura fixa para os cards
        constraints: const BoxConstraints(
          minHeight: 70.0,
          maxWidth: 300.0,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context)
              .secondaryBackground, // Cor de fundo dos cards fornecidos
          boxShadow: const [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context)
                .alternate, // Bordas consistentes com o design
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.blue),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity, // Botão ocupa toda a largura do card
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }