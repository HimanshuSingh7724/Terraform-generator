import React, { useEffect, useState } from 'react';
import axios from 'axios';

function App() {
  const [items, setItems] = useState([]);
  const [input, setInput] = useState('');

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchItems = async () => {
    const res = await axios.get('http://localhost:5000/items');
    setItems(res.data);
  };

  const addItem = async () => {
    if (input.trim() === '') return;
    await axios.post('http://localhost:5000/items', { name: input });
    setInput('');
    fetchItems();
  };

  return (
    <div>
      <h1>Items List</h1>
      <input value={input} onChange={e => setInput(e.target.value)} />
      <button onClick={addItem}>Add</button>
      <ul>
        {items.map(item => <li key={item.id}>{item.name}</li>)}
      </ul>
    </div>
  );
}

export default App;
