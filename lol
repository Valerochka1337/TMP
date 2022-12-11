#include <iostream>
#include <vector>

struct Node {
  int val;
  unsigned int height = 1;
  Node* parent = nullptr;
  Node* left_kid = nullptr;
  Node* right_kid = nullptr;
  Node(int value) {
    val = value;
  }
};

class BST {
  Node* root = nullptr;

  int get_height(Node* node) {
    if (node != nullptr) {
      return node->height;
    } else {
      return 0;
    }
  }

  int bfactor(Node* node) {
    return get_height(node->right_kid) - get_height(node->left_kid);
  }

  void fix_height(Node* node) {
    int hl = get_height(node->left_kid);
    int hr = get_height(node->right_kid);
    node->height = std::max(hl, hr) + 1;
  }

  Node* rotate_right(Node* node) {
    Node* q = node;
    node = node->left_kid;
    q->left_kid = node->right_kid;
    node->right_kid = q;
    fix_height(q);
    fix_height(node);
    return node;
  }

  Node* rotate_left(Node* node) {
    Node* q = node;
    node = node->right_kid;
    q->right_kid = node->left_kid;
    node->left_kid = q;
    fix_height(q);
    fix_height(node);
    return node;
  }

  Node* balance(Node* node) {
    fix_height(node);
    if (bfactor(node) == 2) {
      if (bfactor(node->right_kid) < 0)
        node->right_kid = rotate_right(node->right_kid);
      return rotate_left(node);
    }
    if (bfactor(node) == -2) {
      if (bfactor(node->left_kid) > 0)
        node->left_kid = rotate_left(node->left_kid);
      return rotate_right(node);
    }
    return node;
  }

  Node* searchKey(Node* cur_node, int val) {
    if (cur_node->val == val) {
      return cur_node;
    }

    if (cur_node->left_kid != nullptr && cur_node->val > val) {
      return searchKey(cur_node->left_kid, val);
    } else if (cur_node->right_kid != nullptr && cur_node->val < val) {
      return searchKey(cur_node->right_kid, val);
    } else {
      return nullptr;
    }
  }

  Node* findMax(Node* node) {
    if (node->right_kid != nullptr) {
      return findMax(node->right_kid);
    }
    return node;
  }

  Node* removeMax(Node* node) {
    if (node->right_kid == nullptr) {
      return node->left_kid;
    }
    node->right_kid = removeMax(node->right_kid);
    return balance(node);
  }

  Node* remove(Node* node, int k) {
    if (node == nullptr) return nullptr;
    if (k < node->val)
      node->left_kid = remove(node->left_kid, k);
    else if (k > node->val)
      node->right_kid = remove(node->right_kid, k);
    else {
      Node* left_kid = node->left_kid;
      Node* right_kid = node->right_kid;
      if (right_kid == nullptr && left_kid == nullptr) {
        delete node;
        return nullptr;
      } else if (left_kid == nullptr) {
        delete node;
        return balance(right_kid);
      }
      Node* max = findMax(left_kid);
      left_kid = removeMax(left_kid);
      node->val = max->val;
      Node* tmp  = max->left_kid;
      delete max;
      return balance(node);
    }
    return balance(node);
  }
 public:
  Node* insert(Node* p, int k) {
    if (p == nullptr) {
      return new Node(k);
    }
    if (k < p->val)
      p->left_kid = insert(p->left_kid, k);
    else if (k > p->val)
      p->right_kid = insert(p->right_kid, k);
    return balance(p);
  }

  void insertKey(int val) {
    root = insert(root, val);
  }

  void existsKey(int val) {
    Node* node = nullptr;
    if (root != nullptr) node = searchKey(root, val);
    if (node == nullptr) {
      std::cout << "N\n";
    } else {
      std::cout << "Y\n";
    }
  }

  void deleteKey(int val) {
    root = remove(root, val);
  }

  void printRoot() {
    std::cout << bfactor(root) << '\n';
  }
};

int main() {
  BST tree;
  int n;
  std::cin >> n;
  for (int i = 0; i < n; ++i) {
    char c;
    int k;
    std::cin >> c >> k;
    if (c == 'C') {
      tree.existsKey(k);
    } else if (c == 'A') {
      tree.insertKey(k);
      tree.printRoot();
    } else {
      tree.deleteKey(k);
      tree.printRoot();
    }
  }

  return 0;
}
