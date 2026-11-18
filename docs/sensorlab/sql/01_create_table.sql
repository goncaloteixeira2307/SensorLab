-- Tabela de leituras de sensores (base de dados: sensorlab)
CREATE TABLE IF NOT EXISTS leituras (
    id SERIAL PRIMARY KEY,
    sensor VARCHAR(100),
    valor NUMERIC,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
